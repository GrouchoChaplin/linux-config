#!/usr/bin/env bash
#
# find_latest_versions_parallel.sh
#
# Recursively find the latest N versions of a specific file pattern.
# Uses GNU parallel for fast multi-core traversal.
#
# Usage:
#   ./find_latest_versions_parallel.sh \
#       --folder <dir> --pattern <file_pattern> --count <N> \
#       [--include <pattern>] [--exclude <path> ...] \
#       [--log <file>] [--follow-symlinks] [--unused-procs <M>]
#
# Examples:
#   ./find_latest_versions_parallel.sh \
#       --folder ~/ --pattern '*.cfg' --include '*proj*' --count 10
#
#   ./find_latest_versions_parallel.sh \
#       --folder /data --pattern '*.json' --include '*backup*' \
#       --exclude /data/tmp --exclude /data/cache --count 5

set -euo pipefail

# --- Auto-elevate if not root ---
if [[ $EUID -ne 0 ]]; then
  echo "⚠️  Not running as root — re-executing with sudo..."
  exec sudo "$0" "$@"
fi

# --- Default values ---
FOLDER="."
PATTERN="*"
COUNT=5
LOGFILE=""
FOLLOW_SYMLINKS=0
UNUSED_PROCS=1
EXCLUDES=()
INCLUDES=()

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --folder) FOLDER="$2"; shift 2 ;;
    --pattern) PATTERN="$2"; shift 2 ;;
    --count) COUNT="$2"; shift 2 ;;
    --log) LOGFILE="$2"; shift 2 ;;
    --follow-symlinks) FOLLOW_SYMLINKS=1; shift ;;
    --unused-procs) UNUSED_PROCS="$2"; shift 2 ;;
    --exclude) EXCLUDES+=("$2"); shift 2 ;;
    --include) INCLUDES+=("$2"); shift 2 ;;
    --help)
      echo "Usage: $0 --folder DIR --pattern PATTERN --count N [--include PATTERN...] [--exclude PATH...] [--log FILE] [--follow-symlinks] [--unused-procs M]"
      exit 0
      ;;
    *)
      echo "❌ Unknown option: $1"; exit 1 ;;
  esac
done

# --- Validate ---
if [[ ! -d "$FOLDER" ]]; then
  echo "❌ Error: Folder '$FOLDER' not found" >&2
  exit 1
fi

# --- Calculate available parallel jobs ---
TOTAL_CORES=$(nproc)
AVAILABLE_CORES=$(( TOTAL_CORES - UNUSED_PROCS ))
if (( AVAILABLE_CORES < 1 )); then
  AVAILABLE_CORES=1
fi

echo "🧮 Total cores: $TOTAL_CORES | Leaving $UNUSED_PROCS free → Using $AVAILABLE_CORES parallel jobs"

# --- Prepare find flags ---
FIND_FLAGS=(-type d)
if [[ "$FOLLOW_SYMLINKS" -eq 1 ]]; then
  FIND_FLAGS=(-L -type d)
fi

# --- Build exclusion and inclusion filters ---
EXCLUDE_EXPR=(
  \( -path /proc -o -path /sys -o -path /dev -o -path /run
)
for EX in "${EXCLUDES[@]}"; do
  EXCLUDE_EXPR+=( -o -path "$EX" )
done
EXCLUDE_EXPR+=( -prune \) -o )

INCLUDE_EXPR=()
if [[ ${#INCLUDES[@]} -gt 0 ]]; then
  INCLUDE_EXPR+=( \( )
  for ((i=0; i<${#INCLUDES[@]}; i++)); do
    PAT="${INCLUDES[$i]}"
    INCLUDE_EXPR+=( -path "*/${PAT}" )
    if (( i < ${#INCLUDES[@]} - 1 )); then
      INCLUDE_EXPR+=( -o )
    fi
  done
  INCLUDE_EXPR+=( \) )
fi

# --- Perform search in parallel ---
RESULTS=$(
  find "$FOLDER" "${EXCLUDE_EXPR[@]}" "${FIND_FLAGS[@]}" -print0 2>/dev/null \
  | {
      if [[ ${#INCLUDE_EXPR[@]} -gt 0 ]]; then
        # Filter directories by include pattern before sending to parallel
        xargs -0 -r -n1 bash -c '
          for dir; do
            [[ "$dir" == *"$0"* ]] && printf "%s\0" "$dir"
          done
        ' "${INCLUDES[@]}"
      else
        cat
      fi
    } \
  | parallel -0 -j"$AVAILABLE_CORES" --no-notice \
      "find '{}' -maxdepth 1 -type f -name '$PATTERN' -printf '%T@ %p\n' 2>/dev/null" \
  | sort -nr | head -n "$COUNT"
)

# --- Display ---
echo
echo "🔍 Searching '$FOLDER' for '$PATTERN' (latest $COUNT):"
[[ ${#INCLUDES[@]} -gt 0 ]] && echo "🎯 Only including subfolders matching: ${INCLUDES[*]}"
[[ ${#EXCLUDES[@]} -gt 0 ]] && echo "🚫 Excluding: ${EXCLUDES[*]}"
echo "------------------------------------------------------"
echo "$RESULTS" | awk '{ $1=strftime("[%Y-%m-%d %H:%M:%S]", $1); print $1, $2 }'
echo

# --- Optional logging ---
if [[ -n "$LOGFILE" ]]; then
  {
    echo "===== $(date '+%Y-%m-%d %H:%M:%S') ====="
    echo "Search folder: $FOLDER"
    echo "Pattern: $PATTERN"
    echo "Included: ${INCLUDES[*]:-(none)}"
    echo "Excluded: ${EXCLUDES[*]:-(none)}"
    echo "Latest $COUNT results:"
    echo "$RESULTS" | awk '{ $1=strftime("[%Y-%m-%d %H:%M:%S]", $1); print $1, $2 }'
    echo
  } >> "$LOGFILE"
  echo "📝 Logged results to: $LOGFILE"
fi
