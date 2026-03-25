#!/usr/bin/env bash
# restore_rocky8_repos.sh
# Restores official Rocky Linux 8 repo files and refreshes cache

set -e

ZIP_FILE="rocky8-repo-files-with-gpg.zip"
#DEST_DIR="/etc/yum.repos.d"
DEST_DIR="./yum.repos.d"

echo "==> Restoring Rocky Linux 8 repository configuration..."
if [[ ! -f "$ZIP_FILE" ]]; then
  echo "Error: $ZIP_FILE not found in current directory."
  exit 1
fi

sudo unzip -o "$ZIP_FILE" -d "$DEST_DIR"
sudo chmod 644 $DEST_DIR/rocky8_repos/*.repo
sudo cp -f $DEST_DIR/rocky8_repos/RPM-GPG-KEY-rockyofficial /etc/pki/rpm-gpg/
sudo chown root:root /etc/pki/rpm-gpg/RPM-GPG-KEY-rockyofficial

echo "==> Cleaning and rebuilding DNF cache..."
sudo dnf clean all
sudo dnf makecache

echo "==> Verifying repository setup..."
sudo dnf repolist

echo "✅ Rocky Linux 8 repositories restored successfully."
