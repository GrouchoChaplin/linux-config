#!/bin/bash
# --------------------------------------------------------------------
# prepare_tcl_sdcard_findmnt.sh
# Robust SD card setup utility for TCL Flip 3 (T435S)
# Works with GUI mounts, USB readers, or mmc devices.
# --------------------------------------------------------------------

set -e

VCF_SOURCE="${1:-$HOME/contacts.vcf}"
MUSIC_SRC_DIR="${HOME}/MusicToCopy"
RINGTONE_SRC_DIR="${HOME}/RingtonesToCopy"

echo "📱 TCL Flip 3 SD Card Setup Utility (findmnt version)"

# --- Step 1: Verify source VCF ---
if [[ ! -f "$VCF_SOURCE" ]]; then
  echo "❌ Error: VCF file not found: $VCF_SOURCE"
  echo "Usage: $0 /path/to/contacts.vcf"
  exit 1
fi

# --- Step 2: Detect SD card mount using findmnt ---
SD_MOUNT=$(findmnt -t vfat,exfat -o TARGET -n | head -n1)

if [[ -z "$SD_MOUNT" ]]; then
  echo "⚠️  No mounted FAT32/exFAT device found."
  echo "👉 Please insert your SD card and make sure it’s mounted."
  echo "You can verify with: findmnt -t vfat,exfat"
  exit 1
fi

echo "💽 Detected SD card mounted at: $SD_MOUNT"

# --- Step 3: Create folder structure ---
echo "📂 Creating standard folders..."
for folder in Music Ringtones Pictures Videos; do
  mkdir -pv "$SD_MOUNT/$folder"
done

# --- Step 4: Copy contacts file ---
DEST_VCF="$SD_MOUNT/contacts.vcf"
echo "📇 Copying $VCF_SOURCE → $DEST_VCF"
cp -v "$VCF_SOURCE" "$DEST_VCF"

# --- Step 5: Optional: Copy music and ringtones if folders exist ---
if [[ -d "$MUSIC_SRC_DIR" ]]; then
  echo "🎵 Copying music files..."
  cp -v "$MUSIC_SRC_DIR"/* "$SD_MOUNT/Music/" || true
else
  echo "🎵 No MusicToCopy folder found — skipping music copy."
fi

if [[ -d "$RINGTONE_SRC_DIR" ]]; then
  echo "🔔 Copying ringtones..."
  cp -v "$RINGTONE_SRC_DIR"/* "$SD_MOUNT/Ringtones/" || true
else
  echo "🔔 No RingtonesToCopy folder found — skipping ringtone copy."
fi

# --- Step 6: Flush writes to disk ---
sync
echo "✅ Sync complete — files written successfully."

# --- Step 7: Offer to unmount safely ---
read -rp "💡 Do you want to safely eject/unmount the SD card now? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "🔒 Unmounting..."
  if command -v udisksctl &>/dev/null; then
    DEVICE=$(findmnt -t vfat,exfat -o SOURCE -n | head -n1)
    udisksctl unmount -b "$DEVICE" && echo "✅ SD card safely ejected."
  else
    echo "⚠️  udisksctl not found — please remove the card safely from your file manager."
  fi
else
  echo "ℹ️  Leaving SD card mounted — you may eject it manually."
fi

echo "🎉 Done! You can now insert the SD card into your TCL Flip 3 and import contacts."
