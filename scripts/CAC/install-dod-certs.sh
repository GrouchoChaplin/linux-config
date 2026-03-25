#!/usr/bin/env bash
#
# Install / Update DoD CAC root & intermediate certificates on Rocky Linux 9
# Replaces old "pki-usgov-dod-cacerts" package (not available on EL9)
#
# Usage: sudo ./install-dod-certs.sh
#

set -euo pipefail

WORKDIR="/tmp/dod-certs"
URL="https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/unclass-certificates_pkcs7_DoD.zip"
ANCHOR_DIR="/etc/pki/ca-trust/source/anchors"

echo ">>> Installing prerequisites..."
dnf -y install openssl ca-certificates unzip wget

echo ">>> Preparing workspace..."
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo ">>> Downloading DoD PKCS#7 bundle..."
wget -q "$URL" -O dod-certs.zip

echo ">>> Extracting ZIP..."
unzip -q dod-certs.zip

echo ">>> Searching for PKCS7 bundle file..."
BUNDLE=$(find . -type f \( -iname "*.p7b" -o -iname "*.p7c" \) | head -n1 || true)

if [[ -z "$BUNDLE" ]]; then
  echo "ERROR: Could not find any .p7b or .p7c file in the extracted archive."
  echo "Contents of extracted ZIP:"
  find .
  exit 1
fi

echo ">>> Found bundle: $BUNDLE"

echo ">>> Converting bundle to PEM..."
if ! openssl pkcs7 -print_certs -in "$BUNDLE" -inform DER -out DoD-certs.pem 2>/dev/null; then
  echo ">>> DER parse failed, trying PEM parse..."
  openssl pkcs7 -print_certs -in "$BUNDLE" -out DoD-certs.pem
fi

echo ">>> Splitting PEM into individual .crt files..."
rm -f cert-*.crt || true
csplit -s -f cert- DoD-certs.pem '/-----BEGIN CERTIFICATE-----/' '{*}' || true
for f in cert-*; do
  if grep -q "BEGIN CERTIFICATE" "$f"; then
    mv "$f" "$f.crt"
  else
    rm -f "$f"
  fi
done

CRT_COUNT=$(ls -1 cert-*.crt 2>/dev/null | wc -l)

if [[ "$CRT_COUNT" -eq 0 ]]; then
  echo "ERROR: No certificates were extracted."
  exit 1
fi

echo ">>> Copying $CRT_COUNT certs to $ANCHOR_DIR ..."
cp -v cert-*.crt "$ANCHOR_DIR/"

echo ">>> Updating system trust store..."
update-ca-trust extract

echo ">>> Done!"
echo "Installed $CRT_COUNT DoD certificates."
echo "You can verify with: trust list | grep -i dod"
