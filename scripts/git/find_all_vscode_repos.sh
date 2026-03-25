#!/bin/bash
# Recursively search for Git repos under a given directory,
# and for each repo, find branches containing a .vscode folder
# sorted by most recent change, with colorized output.

# --- Colors ---
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
GRAY="\033[0;90m"
RESET="\033[0m"

ROOT_DIR="${1:-.}"

echo -e "${CYAN}🔍 Scanning for Git repositories under: ${ROOT_DIR}${RESET}"
echo

# Find all .git directories and get their parent paths
mapfile -t repos < <(find "$ROOT_DIR" -type d -name ".git" -prune 2>/dev/null | sed 's|/\.git$||')

if [[ ${#repos[@]} -eq 0 ]]; then
  echo -e "${RED}❌ No Git repositories found under ${ROOT_DIR}.${RESET}"
  exit 1
fi

for repo in "${repos[@]}"; do
  echo -e "\n${CYAN}================================================================${RESET}"
  echo -e "${CYAN}📁 Repository: ${repo}${RESET}"
  echo -e "${CYAN}================================================================${RESET}"

  cd "$repo" || continue

  TMPFILE=$(mktemp)

  # Collect branch info
  git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | while read -r branch; do
    if git ls-tree -r --name-only "$branch" 2>/dev/null | grep -q '^\.vscode/'; then
      loginfo=$(git log -1 --format="%ct|%cr|%h|%an|$branch" -- .vscode 2>/dev/null)
      if [[ -n "$loginfo" ]]; then
        echo "$loginfo" >> "$TMPFILE"
      fi
    fi
  done

  if [[ ! -s "$TMPFILE" ]]; then
    echo -e "${GRAY}No .vscode folder found in any branch.${RESET}"
    rm -f "$TMPFILE"
    continue
  fi

  printf "${YELLOW}%-25s | %-12s | %-10s | %-20s | %s${RESET}\n" "Branch" "When" "Commit" "Author" "Files"
  echo -e "${GRAY}--------------------------------------------------------------------------------------------------------------------${RESET}"

  sort -t'|' -k1,1nr "$TMPFILE" | while IFS='|' read -r timestamp reltime commit author branch; do
    files=$(git ls-tree -r "$branch" --name-only 2>/dev/null | grep '^\.vscode/' | sed 's|^\.vscode/||' | paste -sd "," -)

    now=$(date +%s)
    age=$(( (now - timestamp) / 86400 ))
    if (( age <= 7 )); then color=$GREEN
    elif (( age <= 30 )); then color=$YELLOW
    else color=$GRAY
    fi

    printf "${color}%-25s | %-12s | %-10s | %-20s | %s${RESET}\n" "$branch" "$reltime" "$commit" "$author" "$files"
  done

  rm -f "$TMPFILE"
  echo -e "${GREEN}✅ Finished: ${repo}${RESET}\n"
done

echo -e "${CYAN}🏁 Search complete.${RESET}"
