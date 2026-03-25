#!/usr/bin/env bash
set -euo pipefail

FOLDER=""
USERNAME=""
GROUPNAME=""
FOLLOW_SYMLINKS="skip"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --folder) FOLDER="$2"; shift 2 ;;
    --username) USERNAME="$2"; shift 2 ;;
    --groupname) GROUPNAME="$2"; shift 2 ;;
    --follow-symlinks) FOLLOW_SYMLINKS="$2"; shift 2 ;;
    *) echo "Usage: $0 --folder <path> --username <user> --groupname <group> [--follow-symlinks skip|link|target]"; exit 1 ;;
  esac
done

[[ -z "$FOLDER" || -z "$USERNAME" || -z "$GROUPNAME" ]] && {
  echo "❌ Missing required args"; exit 1; }
[[ ! -d "$FOLDER" ]] && { echo "❌ Folder not found: $FOLDER"; exit 1; }

[[ ! "$FOLLOW_SYMLINKS" =~ ^(skip|link|target)$ ]] && {
  echo "❌ Invalid symlink mode: $FOLLOW_SYMLINKS"; exit 1; }

TIMESTAMP=$(date +%F_%H%M%S)
SYS_LOG="/var/log/chown_audit_${TIMESTAMP}.log"
LOCAL_LOG="${FOLDER%/}/chown_audit_${TIMESTAMP}.log"

sudo touch "$SYS_LOG" && sudo chmod 644 "$SYS_LOG"
touch "$LOCAL_LOG"

echo "📁 Folder : $FOLDER"
echo "👤 Owner  : $USERNAME:$GROUPNAME"
echo "🔗 Mode   : $FOLLOW_SYMLINKS"
echo "📝 Logs   : $SYS_LOG and $LOCAL_LOG"
echo "⚙️  Running..."

FIND_CMD=(find "$FOLDER")
CHOWN_FLAGS=()
case "$FOLLOW_SYMLINKS" in
  skip) FIND_CMD+=('!' '-type' 'l') ;;
  link) CHOWN_FLAGS+=('-h') ;;
  target) FIND_CMD=('find' '-L' "$FOLDER") ;;
esac

if command -v parallel >/dev/null 2>&1; then
  echo "🚀 Using GNU Parallel ($(nproc) cores)"
  "${FIND_CMD[@]}" -print0 | sudo parallel -0 -j"$(nproc)" bash -c '
    for path; do
      if chown '"${CHOWN_FLAGS[*]}"' '"$USERNAME:$GROUPNAME"' "$path"; then
        entry="$(date "+%F %T") : Changed ownership of $path"
        echo "$entry" | sudo tee -a "'"$SYS_LOG"'" >/dev/null
        echo "$entry" >> "'"$LOCAL_LOG"'"
      fi
    done
  ' bash
else
  echo "⚠️  GNU Parallel not found — using xargs fallback."
  "${FIND_CMD[@]}" -print0 | sudo xargs -0 -I{} bash -c '
    path="$1"
    if chown '"${CHOWN_FLAGS[*]}"' '"$USERNAME:$GROUPNAME"' "$path"; then
      entry="$(date "+%F %T") : Changed ownership of $path"
      echo "$entry" | sudo tee -a "'"$SYS_LOG"'" >/dev/null
      echo "$entry" >> "'"$LOCAL_LOG"'"
    fi
  ' _ {}
fi

echo "✅ Done. Logs:"
echo "   - $SYS_LOG"
echo "   - $LOCAL_LOG"
