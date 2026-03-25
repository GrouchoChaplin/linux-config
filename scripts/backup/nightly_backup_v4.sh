#!/usr/bin/env bash
#
# Parallelized Nightly Backup Script (v4)
# --------------------------------------
# Features:
#   - Parallel rsync using GNU parallel
#   - Configurable excludes (~/.backup_excludes)
#   - Locking to prevent overlap
#   - Full logging with rotation
#   - Optional checksum verification
#   - Optional desktop and/or email notification
#   - Cron-safe (via flock)
#
# Recommended cron entry:
#   0 0 * * * /bin/bash -lc "$HOME/projects/scripts/backup/nightly_backup_v4.sh"

set -euo pipefail

# ---------------------------------------------------------
# Configuration
# ---------------------------------------------------------
TODAY=$(date +%F)
NOW=$(date +%F-%H%M%S)
START_TS=$(date +%s)

BASE="/run/media/peddycoartte/MasterBackup"
SRC_HOME="/home/peddycoartte"
DEST_HOME="$BASE/Nightly"

LOG_DIR="$HOME/logs"
LOCKFILE="$HOME/.lock_nightly_backup.lock"
EXCLUDES="$HOME/.backup_excludes"
RETENTION_DAYS=30
JOBS=$(( $(nproc) - 8 ))   # Leave 8 CPU cores free
VERIFY_CHECKSUMS=false     # Set to true for checksum verification
ENABLE_DESKTOP_NOTIFY=true # Set to true for desktop notifications
ENABLE_EMAIL_NOTIFY=false  # Set to true for email notifications
MAIL_TO="peddycoartte@localhost"  # Change as needed (requires 'mail' or 'mailx')

mkdir -p "$DEST_HOME" "$LOG_DIR"
LOGFILE="${LOG_DIR}/nightly_backup-${NOW}.log"
exec > >(tee -a "$LOGFILE") 2>&1

# ---------------------------------------------------------
# Pre-checks
# ---------------------------------------------------------
if ! command -v parallel >/dev/null 2>&1; then
  echo "[!] GNU parallel not found. Installing..."
  sudo dnf install -y parallel || {
    echo "❌ Failed to install GNU parallel. Exiting."
    exit 1
  }
fi

if [ ! -f "$EXCLUDES" ]; then
  echo "[!] Creating default exclude file at $EXCLUDES"
  cat > "$EXCLUDES" <<'EOF'
.cache/
Downloads/
Trash/
*.iso
*.tmp
EOF
fi

# ---------------------------------------------------------
# Lock handling (prevents overlap)
# ---------------------------------------------------------
exec 9>"$LOCKFILE"
if ! flock -n 9; then
  echo "[$NOW] Another backup process is already running. Exiting."
  exit 0
fi

# ---------------------------------------------------------
# Start logging
# ---------------------------------------------------------
echo "=========================================================="
echo "[$NOW] Starting nightly backup"
echo "Backup log: $LOGFILE"
echo "Source: $SRC_HOME"
echo "Destination: $DEST_HOME"
echo "Parallel jobs: $JOBS"
echo "Excludes file: $EXCLUDES"
echo "=========================================================="

STATUS="SUCCESS"
MESSAGE="Nightly backup completed successfully."

# ---------------------------------------------------------
# Backup execution (parallelized rsync)
# ---------------------------------------------------------
{
  find "$SRC_HOME" -mindepth 1 -maxdepth 1 -type d | \
    parallel -j"$JOBS" --eta '
      NAME=$(basename {});
      echo "→ Backing up $NAME..."
      rsync -aHAX --delete \
        --link-dest="'$DEST_HOME'/latest" \
        --exclude-from="'$EXCLUDES'" \
        "{}" "'$DEST_HOME'/$TODAY/$NAME/"
    '
} || { STATUS="FAILED"; MESSAGE="Backup process encountered errors."; }

ln -sfn "$DEST_HOME/$TODAY" "$DEST_HOME/latest"
echo "[$(date +%F-%H%M%S)] Backup completed."

# ---------------------------------------------------------
# Cleanup old backups & logs
# ---------------------------------------------------------
echo "[$(date +%F-%H%M%S)] Cleaning up backups older than $RETENTION_DAYS days..."
find "$DEST_HOME" -maxdepth 1 -type d -name "20*" -mtime +$RETENTION_DAYS ! -name "latest" -exec rm -rf {} \; -exec echo "Deleted {}" \;
find "$LOG_DIR" -type f -name "nightly_backup-*.log" -mtime +$RETENTION_DAYS -exec rm -f {} \;

# ---------------------------------------------------------
# Optional checksum verification
# ---------------------------------------------------------
if [ "$VERIFY_CHECKSUMS" = true ]; then
  echo "[$(date +%F-%H%M%S)] Generating checksum manifest..."
  cd "$DEST_HOME/$TODAY"
  find . -type f -print0 | parallel -0 sha256sum > SHA256SUMS
  echo "[$(date +%F-%H%M%S)] Verifying checksum integrity..."
  if ! sha256sum -c SHA256SUMS | tee -a "$LOGFILE"; then
    STATUS="FAILED"
    MESSAGE="Backup completed but checksum verification failed!"
  fi
fi

# ---------------------------------------------------------
# Notifications
# ---------------------------------------------------------
END_TS=$(date +%s)
ELAPSED=$((END_TS - START_TS))
SUMMARY="[$(date +%F-%H%M%S)] $MESSAGE (${ELAPSED}s)\nLog: $LOGFILE"

if [ "$ENABLE_DESKTOP_NOTIFY" = true ] && command -v notify-send >/dev/null 2>&1; then
  TITLE="Nightly Backup: $STATUS"
  if [ "$STATUS" = "SUCCESS" ]; then
    notify-send -i dialog-information "$TITLE" "$SUMMARY"
  else
    notify-send -i dialog-error "$TITLE" "$SUMMARY"
  fi
fi

if [ "$ENABLE_EMAIL_NOTIFY" = true ] && command -v mail >/dev/null 2>&1; then
  echo -e "$SUMMARY" | mail -s "Nightly Backup: $STATUS" "$MAIL_TO"
fi

# ---------------------------------------------------------
# Done
# ---------------------------------------------------------
echo "$SUMMARY"
echo "=========================================================="
