#!/usr/bin/env bash
#
# find_and_grep.sh
# ----------------
# Recursive search utility with wildcards, exclusions, parallelism,
# colored grep output, and automatic logging with rotation, compression,
# purging, and file modification timestamps.
#
# Usage:
#   ./find_and_grep.sh --root "/path/to/*" \
#                      --folder "folder*" \
#                      --file "*.log" \
#                      --string "error.*timeout" \
#                      [--exclude "build,.git,node_modules"] \
#                      [--parallel] \
#                      [--procs N] \
#                      [--keep N] \
#                      [--purge-old DAYS] \
#                      [--log /path/to/logfile] \
#                      [--rotate-only]
#
# Default behavior:
#   • Keeps 20 most recent logs uncompressed in $SCRIPT_DIR/logs/
#   • Compresses older logs.
#   • If --purge-old is used, deletes logs older than N days.
#   • Displays file modification date/time for each match.
#   • With --rotate-only, performs maintenance and exits.
#

set -euo pipefail

# --- Script identity ---
SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="$(basename "$0")"

# --- Defaults ---
ROOT=""
FOLDER_NAME=""
FILE_NAME=""
SEARCH_STRING=""
EXCLUDES=()
PARALLEL=false
PROCS=0
KEEP=20
PURGE_DAYS=0
LOG_FILE=""
ROTATE_ONLY=false

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)        ROOT="$2"; shift 2 ;;
    --folder)      FOLDER_NAME="$2"; shift 2 ;;
    --file)        FILE_NAME="$2"; shift 2 ;;
    --string)      SEARCH_STRING="$2"; shift 2 ;;
    --exclude)     IFS=',' read -ra EXCLUDES <<< "$2"; shift 2 ;;
    --parallel)    PARALLEL=true; shift ;;
    --procs)       PROCS="$2"; shift 2 ;;
    --keep)        KEEP="$2"; shift 2 ;;
    --purge-old)   PURGE_DAYS="$2"; shift 2 ;;
    --log)         LOG_FILE="$2"; shift 2 ;;
    --rotate-only) ROTATE_ONLY=true; shift ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^#//'
      exit 0 ;;
    *)
      echo "❌ Unknown option: $1" >&2
      exit 1 ;;
  esac
done

# --- Prepare log directory ---
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"

# --- Log maintenance (rotation/compression/purge) ---
rotate_logs() {
  echo "🧹 Managing logs in $LOG_DIR ..."
  mapfile -t LOGS < <(ls -1t "$LOG_DIR"/${SCRIPT_NAME}_*.log* 2>/dev/null || true)

  # Compress logs older than KEEP newest
  if (( ${#LOGS[@]} > KEEP )); then
    OLD_LOGS=("${LOGS[@]:KEEP}")
    for old in "${OLD_LOGS[@]}"; do
      [[ "$old" == *.gz ]] && continue
      echo "🗜️  Compressing old log: $(basename "$old")"
      gzip -f "$old"
    done
  else
    echo "✅ No old logs to compress (total: ${#LOGS[@]}, keep: $KEEP)"
  fi

  # Purge very old logs if requested
  if (( PURGE_DAYS > 0 )); then
    echo "🗑️  Deleting logs older than $PURGE_DAYS days..."
    find "$LOG_DIR" -type f -name "${SCRIPT_NAME}_*.log*" -mtime +$PURGE_DAYS -print -delete || true
  fi
}

# --- Rotate-only mode ---
if $ROTATE_ONLY; then
  rotate_logs
  echo "✅ Log rotation-only mode complete. Exiting."
  exit 0
fi

# --- Validate inputs ---
if [[ -z "$ROOT" || -z "$FOLDER_NAME" || -z "$FILE_NAME" || -z "$SEARCH_STRING" ]]; then
  echo "Usage: $0 --root <dir> --folder <folder> --file <file> --string <pattern> [--exclude <dirs>] [--parallel] [--procs N] [--keep N] [--purge-old DAYS] [--log <file>] [--rotate-only]" >&2
  exit 1
fi

# --- Expand wildcards for root dirs ---
ROOTS=()
while IFS= read -r -d '' dir; do
  ROOTS+=("$dir")
done < <(find $(echo "$ROOT") -mindepth 0 -maxdepth 0 -type d -print0 2>/dev/null || true)

if [[ ${#ROOTS[@]} -eq 0 ]]; then
  echo "❌ No matching root directories found for pattern: $ROOT"
  exit 1
fi

# --- Perform log maintenance before run ---
rotate_logs

# --- Default log file ---
if [[ -z "$LOG_FILE" ]]; then
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}_${TIMESTAMP}.log"
fi

# --- Temp summary file ---
SUMMARY=$(mktemp)
trap 'rm -f "$SUMMARY"' EXIT

{
echo "🔍 Running: $SCRIPT_NAME"
echo "📂 Script path: $SCRIPT_PATH"
echo "📁 Script dir:  $SCRIPT_DIR"
echo "🗂 Log dir:     $LOG_DIR"
echo "──────────────────────────────────────────────"
echo "🔍 Searching roots matching: $ROOT"
echo "📁 Folder pattern: $FOLDER_NAME"
echo "📄 File pattern: $FILE_NAME"
echo "🔎 Search pattern (regex): $SEARCH_STRING"
if [[ ${#EXCLUDES[@]} -gt 0 ]]; then
  echo "🚫 Excluding folders: ${EXCLUDES[*]}"
fi
echo "🧾 Logging to: $LOG_FILE"
echo "🕓 Keeping $KEEP most recent logs uncompressed"
if (( PURGE_DAYS > 0 )); then
  echo "🗑️  Purging logs older than $PURGE_DAYS days"
fi
if $PARALLEL; then
  [[ "$PROCS" -gt 0 ]] && echo "⚙️  Parallel mode with $PROCS processes" || echo "⚙️  Parallel mode (auto cores)"
fi
echo "──────────────────────────────────────────────"

# --- Core search function ---
search_function() {
  local folder="$1"
  local exclude_opts=()
  for ex in "${EXCLUDES[@]}"; do
    exclude_opts+=(-not -path "*/${ex}/*")
  done

  find "$folder" -type f -iname "$FILE_NAME" "${exclude_opts[@]}" -print0 |
  while IFS= read -r -d '' file; do
    local count
    count=$(grep -E -i -c "$SEARCH_STRING" "$file" || true)
    if (( count > 0 )); then
      local mtime
      mtime=$(stat -c "%y" "$file" 2>/dev/null | cut -d'.' -f1)
      echo -e "\n📂 Folder: $folder"
      echo "----------------------------------------------"
      echo "🕓 Last Modified: $mtime"
      grep -Hn --color=always -E -i "$SEARCH_STRING" "$file" || true
      echo "$folder|$file|$count|$mtime" >> "$SUMMARY"
    fi
  done
}

export -f search_function
export FILE_NAME SEARCH_STRING SUMMARY EXCLUDES

# --- Iterate roots ---
for rootdir in "${ROOTS[@]}"; do
  echo
  echo "🌲 Searching in root: $rootdir"
  echo "──────────────────────────────"

  if $PARALLEL && command -v parallel >/dev/null 2>&1; then
    export rootdir
    echo "⚡ Using GNU parallel..."
    PARALLEL_ARGS=()
    [[ "$PROCS" -gt 0 ]] && PARALLEL_ARGS+=("--jobs" "$PROCS")
    PARALLEL_WILL_CITE=1 find "$rootdir" -type d -iname "$FOLDER_NAME" \
      $(for ex in "${EXCLUDES[@]}"; do echo -not -path "*/${ex}/*"; done) \
      -print0 | PARALLEL_WILL_CITE=1 parallel -0 "${PARALLEL_ARGS[@]}" search_function {}
  else
    find "$rootdir" -type d -iname "$FOLDER_NAME" \
      $(for ex in "${EXCLUDES[@]}"; do echo -not -path "*/${ex}/*"; done) \
      -print0 |
    while IFS= read -r -d '' folder; do
      search_function "$folder"
    done
  fi
done

# --- Summary section ---
echo -e "\n✅ Summary of folders containing matches:"
if [[ -s "$SUMMARY" ]]; then
  awk -F'|' '{printf "📁 %s\n  ↳ %s (%s matches, modified %s)\n", $1, $2, $3, $4}' "$SUMMARY" | sort -u
else
  echo "No matches found."
fi

} | tee "$LOG_FILE"

echo
echo "📝 Results saved to: $LOG_FILE"
