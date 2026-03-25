#!/bin/bash
# ===================================================================
# Script: find_vscode_in_jsig_projects.sh
# Purpose:
#   Search a given directory (default: current) for subfolders:
#     1. Top-level folders matching "2025*"
#     2. Within each, folders starting with "proj" (case-insensitive)
#     3. Within those, recursively search for folders matching "*jsig*"
#     4. Within jsig folders, check for a ".vscode" folder
#   Optionally search for a specific file inside found .vscode folders.
#   Sort results by modification time (newest or oldest first).
#
# Usage:
#   ./find_vscode_in_jsig_projects.sh [base_dir] [filename] [--newest|--oldest]
#
# Examples:
#   ./find_vscode_in_jsig_projects.sh
#   ./find_vscode_in_jsig_projects.sh /home/user/Development settings.json
#   ./find_vscode_in_jsig_projects.sh /data/jsig settings.json --oldest
# ===================================================================

# Default values
BASE_DIR="."
SEARCH_FILE=""
SORT_ORDER="--newest"

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --newest|--oldest)
      SORT_ORDER="$arg"
      ;;
    *)
      if [ -z "$BASE_DIR_SET" ]; then
        BASE_DIR="$arg"
        BASE_DIR_SET=1
      elif [ -z "$SEARCH_FILE" ]; then
        SEARCH_FILE="$arg"
      fi
      ;;
  esac
done

# Display search parameters
echo "Base directory : $BASE_DIR"
if [ -n "$SEARCH_FILE" ]; then
  echo "Search file    : $SEARCH_FILE"
else
  echo "Search file    : (none)"
fi
echo "Sort order     : $SORT_ORDER"
echo "--------------------------------------------------------------------"

TMP_RESULTS=$(mktemp)

# Step 1: Find top-level folders matching 2025*
find "$BASE_DIR" -maxdepth 1 -type d -iname "2025*" | while read -r year_folder; do
  # Step 2: Find subfolders starting with "proj" (case-insensitive)
  find "$year_folder" -maxdepth 1 -type d -iname "proj*" | while read -r proj_folder; do
    # Step 3: Recursively find jsig-related folders
    find "$proj_folder" -type d -iname "*jsig*" | while read -r jsig_folder; do
      vscode_path="$jsig_folder/.vscode"
      if [ -d "$vscode_path" ]; then
        if [ -n "$SEARCH_FILE" ]; then
          # Look for file inside .vscode folder
          found_file=$(find "$vscode_path" -maxdepth 1 -type f -iname "$SEARCH_FILE" 2>/dev/null)
          if [ -n "$found_file" ]; then
            echo "$found_file" >> "$TMP_RESULTS"
          fi
        else
          echo "$vscode_path" >> "$TMP_RESULTS"
        fi
      fi
    done
  done
done

echo "--------------------------------------------------------------------"
echo "Sorting results by modification time ($SORT_ORDER)..."
echo

if [ -s "$TMP_RESULTS" ]; then
  # Use stat to get timestamps and sort based on chosen order
  if [ "$SORT_ORDER" = "--oldest" ]; then
    while IFS= read -r path; do
      stat --format='%Y %n' "$path"
    done < "$TMP_RESULTS" | sort -n | cut -d' ' -f2-
  else
    while IFS= read -r path; do
      stat --format='%Y %n' "$path"
    done < "$TMP_RESULTS" | sort -nr | cut -d' ' -f2-
  fi
else
  echo "No matching results found."
fi

rm -f "$TMP_RESULTS"

echo
echo "--------------------------------------------------------------------"
echo "Search complete."
