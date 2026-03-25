#!/usr/bin/env bash
#
# get-rocky.sh <version> [--list]
# Download Rocky Linux <version> live ISOs and checksum files,
# ordered by size (smallest first), then verify.
#
# Example:
#   ./get-rocky.sh 10        # download Rocky Linux 10
#   ./get-rocky.sh 9 --list  # show file list only (no download)
#

set -euo pipefail

# --- Input handling ---
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 <rocky-version> [--list]"
    echo "Example: $0 10"
    echo "         $0 9 --list"
    exit 1
fi

ROCKY_VER="$1"
DRY_RUN="${2:-}"
URL="https://dl.rockylinux.org/pub/rocky/${ROCKY_VER}/live/x86_64/"
TARGET_DIR="./${ROCKY_VER}/live/x86_64"

mkdir -p "$TARGET_DIR"

echo "=== Fetching file list with sizes from Rocky Linux $ROCKY_VER repo ==="
wget -r -np -nH --cut-dirs=2 --spider "$URL" 2>&1 \
  | awk '/^--/ {url=$3} /^Length/ {print $2, url}' \
  | sort -n \
  | awk '{print $2}' \
  | grep -E '(\.iso|CHECKSUM|sha256|sha512)' > filelist.txt

if [ "$DRY_RUN" = "--list" ]; then
    echo "=== Dry run mode: showing files that would be downloaded (smallest → largest) ==="
    cat filelist.txt
    exit 0
fi

echo "=== Downloading files (smallest first) into $TARGET_DIR ==="
wget -c -i filelist.txt -P "$TARGET_DIR"

cd "$TARGET_DIR"

echo "=== Verifying checksums ==="

# Check SHA-256
if [ -f CHECKSUM ]; then
    echo "Verifying with CHECKSUM (sha256)..."
    sha256sum -c CHECKSUM || { echo "SHA-256 verification FAILED"; exit 1; }
elif ls *sha256* >/dev/null 2>&1; then
    echo "Verifying with *sha256* file..."
    sha256sum -c *sha256* || { echo "SHA-256 verification FAILED"; exit 1; }
else
    echo "No SHA-256 checksum file found."
fi

# Check SHA-512
if ls *sha512* >/dev/null 2>&1; then
    echo "Verifying with *sha512* file..."
    sha512sum -c *sha512* || { echo "SHA-512 verification FAILED"; exit 1; }
else
    echo "No SHA-512 checksum file found."
fi

echo "=== All verifications completed for Rocky Linux $ROCKY_VER ==="
