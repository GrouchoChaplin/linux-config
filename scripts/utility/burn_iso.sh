#!/usr/bin/env bash
set -euo pipefail

ISO="${1:-}"

if [[ -z "$ISO" ]]; then
  echo "Usage: $0 /path/to/file.iso"
  exit 1
fi

if [[ ! -f "$ISO" ]]; then
  echo "Error: ISO file not found: $ISO"
  exit 1
fi

echo "=== Detecting removable USB devices ==="
lsblk -o NAME,SIZE,MODEL,TRAN,RM | grep -E "usb|1$" || true

echo
read -rp "Enter the target device (e.g., sdb): " DEV

if [[ -z "$DEV" || ! -b "/dev/$DEV" ]]; then
  echo "Error: /dev/$DEV is not a block device"
  exit 1
fi

echo
echo "WARNING: This will ERASE ALL DATA on /dev/$DEV"
lsblk "/dev/$DEV"
echo
read -rp "Type 'YES' to confirm: " CONFIRM

if [[ "$CONFIRM" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

echo
echo "Writing $ISO to /dev/$DEV ..."
sudo dd if="$ISO" of="/dev/$DEV" bs=4M status=progress oflag=sync

echo "Syncing..."
sync

echo "Write completed!"
echo

# read -rp "Do you want to verify the write with SHA256 (yes/no)? " VERIFY

# if [[ "$VERIFY" =~ ^[Yy][Ee]?[Ss]$ ]]; then
#   echo "Computing SHA256 of ISO..."
#   ISO_SUM=$(sha256sum "$ISO" | awk '{print $1}')
#   echo "ISO SHA256: $ISO_SUM"

#   echo "Computing SHA256 of written device (this may take a while)..."
#   DEV_SUM=$(sudo dd if="/dev/$DEV" bs=4M status=progress | sha256sum | awk '{print $1}')
#   echo "USB SHA256: $DEV_SUM"

#   if [[ "$ISO_SUM" == "$DEV_SUM" ]]; then
#     echo "✅ Verification PASSED: USB matches ISO"
#   else
#     echo "❌ Verification FAILED: USB does not match ISO"
#   fi
# else
#   echo "Skipping verification."
# fi
