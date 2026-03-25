#!/bin/bash
# --------------------------------------------------------------------
# prepare_tcl_sdcard.sh
# Prepare an SD card for use with TCL Flip 3 (T435S)
# Creates proper folder structure and copies contacts/music/ringtones
# --------------------------------------------------------------------

set -e

# === Configuration ===================================================
VCF_SOURCE="${1:-$HOME/contacts.vcf}"      # Default: ~/contacts.vcf
MUSIC_SRC_DIR="${HOME}/MusicToCopy"        # Optional local folder
RINGTONE_SRC_DIR="${HOME}/RingtonesToCopy" # Optional local folder
# =====================================================================

echo "📱 TCL Flip 3 SD Card Setup Utility"

# --- Step 1: Verify VCF file ---
if [[ ! -f "$VCF_SOURCE" ]]; then
  echo "❌ Error: Could not find VCF file at $VCF_SOURCE"
  echo "Usage: $0 /path/to/contacts.vcf"
  exit 1
fi

# --- Step 2: Detect SD card mount ---
SD_MOUNT=$(lsblk -o NAME,MOUNTPOINT,FSTYPE,TRAN | grep -E "sd[b-z].*part.*(usb|mmc)" | awk '{print $2}' | head -n1)
if [[ -z "$SD_MOUNT" ]]; then
  echo "⚠️  No removable drive detected. Insert your SD card and try again."
  exit 1
fi
echo "💽 Detected SD card mounted at: $SD_MOUNT"

# --- Step 3: Verify filesystem ---
FS_TYPE=$(lsblk -no FSTYPE "$SD_MOUNT" | head -n1)
if [[ "$FS_TYPE" != "vfat" ]]; then
  echo "⚠️  Warning: Filesystem is $FS_TYPE, not FAT32 (vfat)."
  echo "👉 TCL Flip 3 works best with FAT32. You can reformat with:"
  echo "   sudo mkfs.vfat -F32 /dev/sdX1"
else
  echo "✅ Filesystem check passed: FAT32"
fi

# --- Step 4: Create folder structure ---
echo "📂 Creating standard folders..."
for folder in Music Ringtones Pictures Videos; do
  mkdir -pv "$SD_MOUNT/$folder"
done

# --- Step 5: Copy contacts ---
echo "📇 Copying contacts.vcf..."
cp -v "$VCF_SOURCE" "$SD_MOUNT/contacts.vcf"

# --- Step 6: Optional content copy ---
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

# --- Step 7: Sync and eject ---
sync
echo "🔒 Sync complete. Attempting safe unmount..."
sudo umount "$SD_MOUNT" && echo "✅ SD card safely ejected."

echo "🎉 Done! Insert your SD card into the TCL Flip 3 and import contacts or play music."
