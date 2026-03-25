#!/usr/bin/env bash
#
# find_files_sorted.sh
# --------------------
# Find files matching patterns, sorted by modification date (newest first),
# with optional exclusions, parallelization, and logging.

set -euo pipefail

# --- Defaults ---
ROOT=""
FOLDER_PATTERN=""
FILE_PATTERN=""
EXCLUDES=()
PARALLEL=false
PROCS=0
LOG_FILE=""

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)    ROOT="$2"; shift 2 ;;
    --folder)  FOLDER_PATTERN="$2"; shift 2 ;;
    --file)    FILE_PATTERN="$2"; shift 2 ;;
    --exclude) IFS=',' read -ra EXCLUDES <<< "$2"; shift 2 ;;
    --parallel) PARALLEL=true; shift ;;
    --procs)   PROCS="$2"; shift 2 ;;
    --log)     LOG_FILE="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: $0 --root \"/path/to/*\" --folder \"*sub*folder*\" --file \"*.log\""
      echo "       [--exclude \"build,.git,node_modules\"] [--parallel] [--procs N] [--log logfile]"
      exit 0 ;;
    *) echo "❌ Unknown option: $1"; exit 1 ;;
  esac
done

# --- Validation ---
if [[ -z "$ROOT" || -z "$FOLDER_PATTERN" || -z "$FILE_PATTERN" ]]; then
  echo "❌ Must specify --root, --folder, and --file patterns."
  exit 1
fi

# --- Prepare log file ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$SCRIPT_DIR/logs"
if [[ -z "$LOG_FILE" ]]; then
  LOG_FILE="$SCRIPT_DIR/logs/find_files_$(date +%F_%H-%M-%S).log"
fi

# --- Build exclusion clauses ---
EXCLUDE_OPTS=()
for ex in "${EXCLUDES[@]}"; do
  EXCLUDE_OPTS+=(-not -path "*/${ex}/*")
done

# --- Core search function ---
search_function() {
  local folder="$1"
  find "$folder" -type f -iname "$FILE_PATTERN" "${EXCLUDE_OPTS[@]}" -printf '%T@|%Tc|%p\n'
}

export -f search_function
export FILE_PATTERN EXCLUDE_OPTS

echo "🔍 Searching..."
echo "Root pattern:    $ROOT"
echo "Folder pattern:  $FOLDER_PATTERN"
echo "File pattern:    $FILE_PATTERN"
echo "Log file:        $LOG_FILE"
[[ ${#EXCLUDES[@]} -gt 0 ]] && echo "Excluding:       ${EXCLUDES[*]}"
echo "──────────────────────────────────────────────"

# --- Perform search ---
{
  if $PARALLEL && command -v parallel >/dev/null 2>&1; then
    PARALLEL_ARGS=()
    [[ "$PROCS" -gt 0 ]] && PARALLEL_ARGS+=(--jobs "$PROCS")
    find $ROOT -type d -iname "$FOLDER_PATTERN" "${EXCLUDE_OPTS[@]}" -print0 |
      parallel -0 "${PARALLEL_ARGS[@]}" search_function {} |
      sort -t'|' -k1,1nr
  else
    find $ROOT -type d -iname "$FOLDER_PATTERN" "${EXCLUDE_OPTS[@]}" -print0 |
      while IFS= read -r -d '' folder; do
        search_function "$folder"
      done | sort -t'|' -k1,1nr
  fi
} | awk -F'|' '{printf "🕓 %s | %s\n", $2, $3}' | tee "$LOG_FILE"

echo
echo "✅ Results saved to: $LOG_FILE"
