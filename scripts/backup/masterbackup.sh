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

# Make sure destination exists
mkdir -p "$DEST_HOME" "$DEST_DEV"

echo "Starting Nightly backup of $SRC_HOME..."
rsync -aHAXv --delete \
  --link-dest="$DEST_HOME/latest" \
  --log-file="$BASE/NightlyBackup.$NOW.txt" \
  "$SRC_HOME"/ "$DEST_HOME/$TODAY/"

# Update symlink for "latest"
ln -sfn "$DEST_HOME/$TODAY" "$DEST_HOME/latest"

echo "Starting Development backup of $SRC_DEV..."
rsync -aHAXv --delete \
  --link-dest="$DEST_DEV/latest" \
  --log-file="$BASE/DevelopmentFolderBackup.$NOW.txt" \
  "$SRC_DEV"/ "$DEST_DEV/$TODAY/"

# Update symlink for "latest"
ln -sfn "$DEST_DEV/$TODAY" "$DEST_DEV/latest"

echo "Backup completed at $NOW."
