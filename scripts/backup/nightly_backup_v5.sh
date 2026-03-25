#!/usr/bin/env bash
#
# Parallelized Nightly Backup Script (v5)
# --------------------------------------
# Features:
#   - Creates dated destination folder ($DEST_HOME/YYYY-MM-DD)
#   - Auto-increments backup iteration (000001, 000002, ...)
#   - Maintains symlink "latest" to most recent backup
#   - Parallel rsync with exclude list
#   - Locking to prevent overlap
#   - Full logging (in DEST_HOME)
#   - Optional desktop/email notification
#   - Cron-safe
#
# Recommended cron entry:
#   0 0 * * * /bin/bash -lc "$HOME/projects/scripts/backup/nightly_backup_v5.sh"

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

EXCLUDES="$HOME/.backup_excludes"
LOCKFILE="$HOME/.lock_nightly_backup.lock"
RETENTION_DAYS=30
JOBS=$(( $(nproc) - 8 ))  # Leave 8 cores free

VERIFY_CHECKSUMS=false
ENABLE_DESKTOP_NOTIFY=true
ENABLE_EMAIL_NOTIFY=false
MAIL_TO="peddycoartte@localhost"

mkdir -p "$DEST_HOME"

# ---------------------------------------------------------
# Determine backup iteration and log filename
# ---------------------------------------------------------
LAST_RUN_NUM=$(find "$DEST_HOME" -maxdepth 1 -type f -name "NightlyBackup.${TODAY}-*.txt" \
  | sed -E 's/.*-([0-9]{6})\.txt$/\1/' | sort | tail -n 1)

if [[ -z "$LAST_RUN_NUM" ]]; then
  RUN_NUM=1
else
  RUN_NUM=$((10#$LAST_RUN_NUM + 1))
fi

RUN_ID=$(printf "%06d" "$RUN_NUM")
BACKUP_DIR="$DEST_HOME/$TODAY"
LOGFILE="$DEST_HOME/NightlyBackup.${TODAY}-${RUN_ID}.txt"

mkdir -p "$BACKUP_DIR"
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
echo "[$NOW] Starting nightly backup (Run #$RUN_ID)"
echo "Backup log: $LOGFILE"
echo "Source: $SRC_HOME"
echo "Destination: $BACKUP_DIR"
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
        "{}" "'$BACKUP_DIR'/$NAME/"
    '
} || { STATUS="FAILED"; MESSAGE="Backup process encountered errors."; }

# ---------------------------------------------------------
# Update symlink to latest backup
# ---------------------------------------------------------
ln -sfn "$BACKUP_DIR" "$DEST_HOME/latest"
echo "[$(date +%F-%H%M%S)] Backup complete: $BACKUP_DIR"
echo "Symlink updated: $DEST_HOME/latest -> $BACKUP_DIR"

# ---------------------------------------------------------
# Cleanup old backups & logs
# ---------------------------------------------------------
echo "[$(date +%F-%H%M%S)] Cleaning backups older than $RETENTION_DAYS days..."
find "$DEST_HOME" -maxdepth 1 -type d -name "20*" -mtime +$RETENTION_DAYS ! -name "latest" -exec rm -rf {} \; -exec echo "Deleted {}" \;
find "$DEST_HOME" -type f -name "NightlyBackup.*.txt" -mtime +$RETENTION_DAYS -exec rm -f {} \;

# ---------------------------------------------------------
# Optional checksum verification
# ---------------------------------------------------------
if [ "$VERIFY_CHECKSUMS" = true ]; then
  echo "[$(date +%F-%H%M%S)] Generating checksum manifest..."
  cd "$BACKUP_DIR"
  find . -type f -print0 | parallel -0 sha256sum > SHA256SUMS
  echo "[$(date +%F-%H%M%S)] Verifying checksums..."
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
SUMMARY="[$(date +%F-%H%M%S)] $MESSAGE (${ELAPSED}s)\nBackup folder: $BACKUP_DIR\nLog: $LOGFILE"

if [ "$ENABLE_DESKTOP_NOTIFY" = true ] && command -v notify-send >/dev/null 2>&1; then
  TITLE="Nightly Backup: $STATUS"
  ICON="dialog-information"
  [ "$STATUS" = "FAILED" ] && ICON="dialog-error"
  notify-send -i "$ICON" "$TITLE" "$SUMMARY"
fi

if [ "$ENABLE_EMAIL_NOTIFY" = true ] && command -v mail >/dev/null 2>&1; then
  echo -e "$SUMMARY" | mail -s "Nightly Backup: $STATUS" "$MAIL_TO"
fi

# ---------------------------------------------------------
# Done
# ---------------------------------------------------------
echo "$SUMMARY"
echo "=========================================================="
