#!/usr/bin/env bash
# restore_rocky8_repo.sh
# Restores official Rocky Linux 8 single-file repo configuration

set -e

REPO_FILE="rocky8.repo"
GPG_KEY="RPM-GPG-KEY-rockyofficial"
DEST_DIR="/etc/yum.repos.d"

echo "==> Restoring single-file Rocky Linux 8 repository configuration..."
if [[ ! -f "$REPO_FILE" ]]; then
  echo "Error: $REPO_FILE not found in current directory."
  exit 1
fi

if [[ ! -f "$GPG_KEY" ]]; then
  echo "Error: $GPG_KEY not found in current directory."
  exit 1
fi

sudo cp -f "$REPO_FILE" "$DEST_DIR/rocky8.repo"
sudo cp -f "$GPG_KEY" /etc/pki/rpm-gpg/
sudo chmod 644 "$DEST_DIR/rocky8.repo" /etc/pki/rpm-gpg/RPM-GPG-KEY-rockyofficial
sudo chown root:root "$DEST_DIR/rocky8.repo" /etc/pki/rpm-gpg/RPM-GPG-KEY-rockyofficial

echo "==> Cleaning and rebuilding DNF cache..."
sudo dnf clean all
sudo dnf makecache

echo "==> Verifying repository setup..."
sudo dnf repolist

echo "✅ Single-file Rocky Linux 8 repository configuration restored successfully."
