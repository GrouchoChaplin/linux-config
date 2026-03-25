#!/usr/bin/env bash
#
# Remove DoD CAC root & intermediate certificates from Rocky Linux 9 trust store
# Usage: sudo ./remove-dod-certs.sh
#

set -euo pipefail

ANCHOR_DIR="/etc/pki/ca-trust/source/anchors"

echo ">>> Searching for DoD certs in $ANCHOR_DIR ..."

# Match certs that were installed by our script (cert-XX.crt style) or contain "DoD"
CANDIDATES=$(grep -l "DoD" "$ANCHOR_DIR"/*.crt 2>/dev/null || true)
SCRIPTED=$(ls "$ANCHOR_DIR"/cert-*.crt 2>/dev/null || true)

if [[ -z "$CANDIDATES" && -z "$SCRIPTED" ]]; then
  echo "No DoD certificates found in $ANCHOR_DIR."
  exit 0
fi

echo ">>> The following certs will be removed:"
for f in $CANDIDATES $SCRIPTED; do
  echo "   $f"
done

echo
read -rp "Proceed with removal? [y/N] " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 1
fi

# Remove them
rm -vf $CANDIDATES $SCRIPTED || true

echo ">>> Updating trust store..."
update-ca-trust extract

echo ">>> Done. DoD certificates removed."
