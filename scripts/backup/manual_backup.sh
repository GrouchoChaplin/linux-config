#!/bin/bash

# Timestamp for today's backup
TODAY=$(date +%F)
NOW=$(date +%F-%H%M%S)

# Base backup location (external drive)
BASE="/run/media/peddycoartte/MasterBackup"

# Source folders
SRC_HOME="/home/peddycoartte"
SRC_DEV="/home/peddycoartte/Development"

# Destination folders
DEST_HOME="$BASE/Nightly"
DEST_DEV="$BASE/DevelopmentBackups"

# How many days of backups to keep
RETENTION_DAYS=30

# Make sure destination exists
mkdir -p "$DEST_HOME" "$DEST_DEV"

echo "[$NOW] Starting nightly backup..."

# Home directory backup
rsync -aHAXv --delete \
  --link-dest="$DEST_HOME/latest" \
  --log-file="$BASE/NightlyBackup.$NOW.txt" \
  "$SRC_HOME"/ "$DEST_HOME/$TODAY/"

ln -sfn "$DEST_HOME/$TODAY" "$DEST_HOME/latest"

# Development folder backup
rsync -aHAXv --delete \
  --link-dest="$DEST_DEV/latest" \
  --log-file="$BASE/DevelopmentFolderBackup.$NOW.txt" \
  "$SRC_DEV"/ "$DEST_DEV/$TODAY/"

ln -sfn "$DEST_DEV/$TODAY" "$DEST_DEV/latest"

echo "[$NOW] Backup completed."

# ---------------------------------------------------------
# Cleanup old backups (older than RETENTION_DAYS)
# ---------------------------------------------------------
echo "Cleaning up backups older than $RETENTION_DAYS days..."

find "$DEST_HOME" -maxdepth 1 -type d -name "20*" -mtime +$RETENTION_DAYS -exec rm -rf {} \;
find "$DEST_DEV" -maxdepth 1 -type d -name "20*" -mtime +$RETENTION_DAYS -exec rm -rf {} \;

echo "Cleanup done."
