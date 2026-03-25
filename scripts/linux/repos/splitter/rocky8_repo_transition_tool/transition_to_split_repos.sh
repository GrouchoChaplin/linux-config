#!/usr/bin/env bash
# transition_to_split_repos.sh
# Converts system to use split Rocky Linux repo files instead of a single combined one.
# Usage: sudo bash transition_to_split_repos.sh [split_repo_dir]

set -e

SPLIT_DIR="${1:-/etc/yum.repos.d/split}"
REPO_DIR="/etc/yum.repos.d"
BACKUP_DIR="${REPO_DIR}/backup_$(date +%F_%H%M%S)"

echo "==> Preparing to transition to split repo layout..."
echo "    Source split repo dir: $SPLIT_DIR"
echo "    Destination: $REPO_DIR"
echo "    Backup dir: $BACKUP_DIR"
echo

if [[ ! -d "$SPLIT_DIR" ]]; then
  echo "❌ Error: split repo directory not found at $SPLIT_DIR"
  exit 1
fi

echo "==> Backing up current /etc/yum.repos.d to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp -a ${REPO_DIR}/*.repo "$BACKUP_DIR"/ 2>/dev/null || true

if [[ -f "${REPO_DIR}/rocky8.repo" ]]; then
  echo "==> Disabling combined rocky8.repo..."
  mv "${REPO_DIR}/rocky8.repo" "${REPO_DIR}/rocky8.repo.disabled"
fi

echo "==> Installing split repo files from $SPLIT_DIR..."
cp -a ${SPLIT_DIR}/Rocky-*.repo "${REPO_DIR}/"

chmod 644 ${REPO_DIR}/Rocky-*.repo
chown root:root ${REPO_DIR}/Rocky-*.repo

echo
echo "==> Cleaning and rebuilding DNF metadata..."
dnf clean all -y
dnf makecache -y

echo
echo "==> Listing enabled repositories:"
dnf repolist enabled

echo
echo "✅ Transition complete!"
echo "   - Split repos now active in $REPO_DIR"
echo "   - Old configuration backed up in $BACKUP_DIR"
echo "   - You can re-enable the single file if needed with:"
echo "     mv ${REPO_DIR}/rocky8.repo.disabled ${REPO_DIR}/rocky8.repo"
