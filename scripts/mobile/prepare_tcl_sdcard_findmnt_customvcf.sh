#!/bin/bash
# --------------------------------------------------------------------
# prepare_tcl_sdcard_findmnt_customvcf.sh
# Robust SD card setup utility for TCL Flip 3 (T435S)
# Lets you specify the exact contacts.vcf file path and filename.
# --------------------------------------------------------------------

set -e

echo "📱 TCL Flip 3 SD Card Setup Utility (custom VCF version)"
echo "--------------------------------------------------------"

# === Step 1: Ask for or accept VCF path ===
if [[ -n "$1" ]]; then
  VCF_SOURCE="$1"
else
  read -rp "Enter full path to your contacts VCF file: " VCF_SOURCE
fi

# Normalize and verify
if [[ ! -f "$VCF_SOURCE" ]]; then
  echo "❌ Error: VCF file not found at: $VCF_SOURCE"
  echo "Usage: $0 /path/to/contacts.vcf"
  exit 1
fi

echo "📇 Using VCF file: $VCF_SOURCE"

# === Optional content source directories ===
MUSIC_SRC_DIR="${HOME}/MusicToCopy"
RINGTONE_SRC_DIR="${HOME}/RingtonesToCopy"

# === Step 2: Detect SD card mount using findmnt ===
SD_MOUNT=$(findmnt -t vfat,exfat -o TARGET -n | head -n1)

if [[ -z "$SD_MOUNT" ]]; then
  echo "⚠️  No mounted FAT32/exFAT device found."
  echo "👉 Please insert your SD card and make sure it’s mounted."
  echo "You can verify with: findmnt -t vfat,exfat"
  exit 1
fi

echo "💽 Detected SD card mounted at: $SD_MOUNT"

# === Step 3: Ask user for destination filename ===
DEFAULT_NAME="contacts.vcf"
read -rp "Enter destination filename on SD card [default: $DEFAULT_NAME]: " DEST_NAME
DEST_NAME="${DEST_NAME:-$DEFAULT_NAME}"

DEST_PATH="$SD_MOUNT/$DEST_NAME"

# === Step 4: Create folder structure ===
echo "📂 Creating standard folders..."
for folder in Music Ringtones Pictures Videos; do
  mkdir -pv "$SD_MOUNT/$folder"
done

# === Step 5: Copy contacts file ===
echo "📇 Copying $VCF_SOURCE → $DEST_PATH ..."
cp -v "$VCF_SOURCE" "$DEST_PATH"

# === Step 6: Optional: Copy music and ringtones ===
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

# === Step 7: Sync and unmount ===
sync
echo "✅ Sync complete — files written successfully."

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

echo "🎉 Done! Your VCF file is now on the SD card as '$DEST_NAME'."
