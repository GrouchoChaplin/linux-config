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
DEST_HOME="$BASE/ManualRuns/Home"
DEST_DEV="$BASE/ManualRuns/Development"

# Make sure destination exists
mkdir -p "$DEST_HOME" "$DEST_DEV"

# Home directory backup
rsync -aHAXv \
  --log-file="$BASE/ManualBackupHome.$NOW.txt" \
  "$SRC_HOME"/ "$DEST_HOME/$TODAY/"

# Development folder backup
rsync -aHAXv \
  --log-file="$BASE/ManualBackupDev.$NOW.txt" \
  "$SRC_DEV"/ "$DEST_DEV/$TODAY/"

echo "Manual backup completed at $NOW"
