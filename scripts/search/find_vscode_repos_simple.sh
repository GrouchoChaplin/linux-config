#!/bin/bash
# -----------------------------------------------------------------------------
# find_vscode_repos_simple.sh
#
# Recursively search a top-level directory for Git repositories and check
# whether each repo contains a .vscode folder (in the repo root only).
# Results are sorted by the most recent modification inside that folder.
#
# Usage:
#   ./find_vscode_repos_simple.sh /path/to/TopFolder [--csv]
#
# Options:
#   --csv   Output results to a CSV file in the current directory.
# -----------------------------------------------------------------------------

# --- Colors for output ---
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# --- Argument Parsing ---
if [[ -z "$1" ]]; then
  echo -e "${YELLOW}Usage:${RESET} $0 <TopFolder> [--csv]"
  exit 1
fi

ROOT_DIR="$1"
CSV_MODE=false
[[ "$2" == "--csv" ]] && CSV_MODE=true

# --- File for temporary storage ---
TMPFILE=$(mktemp)

# If CSV output requested, prepare file
if $CSV_MODE; then
  CSV_FILE="vscode_repo_results_$(date +%F_%H%M).csv"
  echo "Date Modified,Repository Path" > "$CSV_FILE"
  echo -e "${CYAN}📁 CSV output enabled:${RESET} $CSV_FILE"
fi

echo -e "${CYAN}🔍 Scanning for Git repositories under:${RESET} $ROOT_DIR"
echo

# -----------------------------------------------------------------------------
# Step 1: Find all Git repositories under the root directory.
# -----------------------------------------------------------------------------
mapfile -t repos < <(find "$ROOT_DIR" -type d -name ".git" -prune -print 2>/dev/null | sed 's|/\.git$||')

if [[ ${#repos[@]} -eq 0 ]]; then
  echo -e "${YELLOW}No Git repositories found under ${ROOT_DIR}.${RESET}"
  exit 0
fi

# -----------------------------------------------------------------------------
# Step 2: Check each repo for a top-level .vscode folder and get last mod time.
# -----------------------------------------------------------------------------
for repo in "${repos[@]}"; do
  if [[ -d "$repo/.vscode" ]]; then
    # Most recent modification timestamp among all files in .vscode
    mod_time=$(find "$repo/.vscode" -type f -printf "%T@\n" 2>/dev/null | sort -nr | head -1)
    [[ -z "$mod_time" ]] && mod_time=$(stat -c "%Y" "$repo/.vscode" 2>/dev/null)
    echo "$mod_time|$repo/.vscode" >> "$TMPFILE"
  fi
done

# -----------------------------------------------------------------------------
# Step 3: Sort and display results (newest first)
# -----------------------------------------------------------------------------
if [[ -s "$TMPFILE" ]]; then
  echo -e "${CYAN}📅 Found .vscode folders (sorted by last modified date):${RESET}"
  echo

  sort -t'|' -k1,1nr "$TMPFILE" | while IFS='|' read -r timestamp path; do
    mod_date=$(date -d @"$timestamp" "+%Y-%m-%d %H:%M:%S")
    echo -e "${GREEN}[$mod_date]${RESET}  $path"

    # Also append to CSV if requested
    if $CSV_MODE; then
      echo "\"$mod_date\",\"$path\"" >> "$CSV_FILE"
    fi
  done
else
  echo -e "${YELLOW}No .vscode folders found in any repositories.${RESET}"
fi

# Cleanup
rm -f "$TMPFILE"

echo
if $CSV_MODE; then
  echo -e "${CYAN}✅ Search complete. CSV saved to:${RESET} $CSV_FILE"
else
  echo -e "${CYAN}✅ Search complete.${RESET}"
fi
