#!/usr/bin/env bash

# find_files_sorted.sh
# --------------------
# Find files matching folder + file patterns, sorted by modification date (newest first),
# with optional exclusions, parallelism, and optional string search inside files.
#
# Usage:
#   ./find_files_sorted.sh --root "/path/to/*" \
#                          --folder "*sub*folder*" \
#                          --file "*.log" \
#                          [--string "error.*timeout"] \
#                          [--exclude "build,.git,node_modules"] \
#                          [--parallel] \
#                          [--procs N] \
#                          [--log /path/to/logfile]
#
# Behavior:
#   • Lists and logs all matching files sorted by modification time (newest first)
#   • Optionally greps for a string pattern inside the files
#   • Logs full file paths, modification times, and match counts
#   • Parallel and exclusion aware
#   • Displays a summary table at the end
#


# Example 1: Just find files (no grep)
#
# ./find_files_sorted.sh \
#   --root "/path/to/*" \
#   --folder "*sub*folder*" \
#   --file "*.log" \
#   --string "error.*timeout" \
#   --exclude "build,.git,node_modules" \
#   --parallel --procs 8 \
#   --log /tmp/found_errors.log

# 💡 Example 2: Find + search for pattern
#
# ./find_files_sorted.sh \
#   --root "/path/to/*" \
#   --folder "*sub*folder*" \
#   --file "*.log" \
#   --string "error.*timeout" \
#   --exclude "build,.git,node_modules" \
#   --parallel --procs 8 \
#   --log /tmp/found_errors.log
#!/usr/bin/env bash
#

set -euo pipefail

# --- Defaults ---
ROOT=""
FOLDER_PATTERN=""
FILE_PATTERN=""
SEARCH_STRING=""
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
    --string)  SEARCH_STRING="$2"; shift 2 ;;
    --exclude) IFS=',' read -ra EXCLUDES <<< "$2"; shift 2 ;;
    --parallel) PARALLEL=true; shift ;;
    --procs)   PROCS="$2"; shift 2 ;;
    --log)     LOG_FILE="$2"; shift 2 ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^#//' | head -n 30
      exit 0 ;;
    *) echo "❌ Unknown option: $1"; exit 1 ;;
  esac
done

# --- Validation ---
if [[ -z "$ROOT" || -z "$FOLDER_PATTERN" || -z "$FILE_PATTERN" ]]; then
  echo "❌ Must specify --root, --folder, and --file patterns." >&2
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
[[ -n "$SEARCH_STRING" ]] && echo "Search string:   $SEARCH_STRING"
[[ ${#EXCLUDES[@]} -gt 0 ]] && echo "Excluding:       ${EXCLUDES[*]}"
echo "Log file:        $LOG_FILE"
echo "──────────────────────────────────────────────"

# --- Perform search ---
RESULTS=$(mktemp)
SUMMARY=$(mktemp)
trap 'rm -f "$RESULTS" "$SUMMARY"' EXIT

if $PARALLEL && command -v parallel >/dev/null 2>&1; then
  PARALLEL_ARGS=()
  [[ "$PROCS" -gt 0 ]] && PARALLEL_ARGS+=(--jobs "$PROCS")
  find $ROOT -type d -iname "$FOLDER_PATTERN" "${EXCLUDE_OPTS[@]}" -print0 |
    parallel -0 "${PARALLEL_ARGS[@]}" search_function {} >> "$RESULTS"
else
  find $ROOT -type d -iname "$FOLDER_PATTERN" "${EXCLUDE_OPTS[@]}" -print0 |
    while IFS= read -r -d '' folder; do
      search_function "$folder"
    done >> "$RESULTS"
fi

# --- Sort and process results ---
sort -t'|' -k1,1nr "$RESULTS" | while IFS='|' read -r _ mtime path; do
  echo "🕓 $mtime | $path"
  if [[ -n "$SEARCH_STRING" ]]; then
    matches=$(grep -Hn --color=never -E -i "$SEARCH_STRING" "$path" 2>/dev/null || true)
    count=$(echo "$matches" | grep -c . || true)
    if (( count > 0 )); then
      echo "$matches"
      echo "$count|$path" >> "$SUMMARY"
    else
      echo "  └─ (no matches)"
      echo "0|$path" >> "$SUMMARY"
    fi
  fi
  echo
done | tee "$LOG_FILE"

# --- Summary report ---
if [[ -n "$SEARCH_STRING" ]]; then
  echo "──────────────────────────────────────────────" | tee -a "$LOG_FILE"
  echo "📊 SUMMARY: Total matches per file for pattern \"$SEARCH_STRING\"" | tee -a "$LOG_FILE"
  echo "──────────────────────────────────────────────" | tee -a "$LOG_FILE"
  sort -t'|' -k1,1nr "$SUMMARY" | awk -F'|' '{printf "%6s  %s\n", $1, $2}' | tee -a "$LOG_FILE"

  total=$(awk -F'|' '{sum+=$1} END {print sum}' "$SUMMARY")
  echo "──────────────────────────────────────────────" | tee -a "$LOG_FILE"
  printf "TOTAL MATCHES: %d\n" "$total" | tee -a "$LOG_FILE"
fi

echo
echo "✅ Results saved to: $LOG_FILE"
