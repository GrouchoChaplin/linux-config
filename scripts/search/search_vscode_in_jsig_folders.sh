#!/bin/bash
# ===================================================================
# Script: find_vscode_in_jsig_projects.sh
# Purpose:
#   Search a given directory (default: current) for subfolders:
#     1. Top-level folders matching "2025*"
#     2. Within each, folders starting with "proj" (case-insensitive)
#     3. Within those, recursively search for folders matching "*jsig*"
#     4. Within jsig folders, check for a ".vscode" folder
#   Optionally, search for a specific file name within found .vscode folders.
#   Results are sorted by modification time (newest first).
# ===================================================================

# Usage:
#   ./find_vscode_in_jsig_projects.sh [base_dir] [filename]
#
# Examples:
#   ./find_vscode_in_jsig_projects.sh
#   ./find_vscode_in_jsig_projects.sh /home/user/Development settings.json
# ===================================================================

BASE_DIR="${1:-.}"
SEARCH_FILE="${2:-}"

echo "Searching under: $BASE_DIR"
if [ -n "$SEARCH_FILE" ]; then
  echo "Looking for file: $SEARCH_FILE inside .vscode folders..."
else
  echo "Looking for .vscode folders only..."
fi
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
          # If a filename is specified, check for it inside the .vscode folder
          found_file=$(find "$vscode_path" -maxdepth 1 -type f -iname "$SEARCH_FILE" 2>/dev/null)
          if [ -n "$found_file" ]; then
            echo "$found_file" >> "$TMP_RESULTS"
          fi
        else
          # Otherwise, just record the .vscode folder
          echo "$vscode_path" >> "$TMP_RESULTS"
        fi
      fi
    done
  done
done

echo "--------------------------------------------------------------------"
echo "Sorting results by modification time (newest first)..."
echo

if [ -s "$TMP_RESULTS" ]; then
  while IFS= read -r path; do
    stat --format='%Y %n' "$path"
  done < "$TMP_RESULTS" | sort -nr | cut -d' ' -f2-
else
  echo "No matching results found."
fi

rm -f "$TMP_RESULTS"

echo
echo "--------------------------------------------------------------------"
echo "Search complete."
