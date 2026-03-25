#!/bin/bash
# Search all local and remote branches for a .vscode folder,
# sort by most recent change, and list contained files.
# Colorized for clarity.

# --- Colors ---
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
GRAY="\033[0;90m"
RESET="\033[0m"

echo -e "${CYAN}🔍 Searching all branches for '.vscode'...${RESET}"

TMPFILE=$(mktemp)

# Collect branch info
git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | while read -r branch; do
  # Check for .vscode folder in this branch
  if git ls-tree -r --name-only "$branch" 2>/dev/null | grep -q '^\.vscode/'; then
    # Get last commit info affecting that folder
    loginfo=$(git log -1 --format="%ct|%cr|%h|%an|$branch" -- .vscode 2>/dev/null)
    if [[ -n "$loginfo" ]]; then
      echo "$loginfo" >> "$TMPFILE"
    fi
  fi
done

echo
echo -e "${CYAN}📅 Sorting results by most recent change to '.vscode'...${RESET}"
echo

printf "${YELLOW}%-25s | %-12s | %-10s | %-20s | %s${RESET}\n" "Branch" "When" "Commit" "Author" "Files"
echo -e "${GRAY}--------------------------------------------------------------------------------------------------------------------${RESET}"

# Sort by timestamp (field 1), newest first
sort -t'|' -k1,1nr "$TMPFILE" | while IFS='|' read -r timestamp reltime commit author branch; do
  # List files in .vscode for this branch
  files=$(git ls-tree -r "$branch" --name-only 2>/dev/null | grep '^\.vscode/' | sed 's|^\.vscode/||' | paste -sd "," -)

  # Age-based color: recent (green), mid (yellow), old (gray)
  now=$(date +%s)
  age=$(( (now - timestamp) / 86400 ))  # in days
  if (( age <= 7 )); then color=$GREEN
  elif (( age <= 30 )); then color=$YELLOW
  else color=$GRAY
  fi

  printf "${color}%-25s | %-12s | %-10s | %-20s | %s${RESET}\n" "$branch" "$reltime" "$commit" "$author" "$files"
done

rm -f "$TMPFILE"
echo
echo -e "${GREEN}✅ Done.${RESET}"
