#!/bin/bash
#
# Usage:
#   ./search_folders.sh \
#       --top-level-folder /path/to/top \
#       --search-folder myfolder \
#       --search-file config.json \
#       [--search-pattern "API_KEY.*"]
#
# Description:
#   1. Finds directories named --search-folder under --top-level-folder.
#   2. Inside each, searches for files named --search-file.
#   3. If --search-pattern is provided, only includes files containing that pattern.
#   4. Outputs full file paths sorted by modification time (newest first).

# ---- Argument defaults ----
top_level_folder=""
search_folder=""
search_file=""
search_pattern=""

# ---- Parse arguments ----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --top-level-folder)
      top_level_folder="$2"; shift 2;;
    --search-folder)
      search_folder="$2"; shift 2;;
    --search-file)
      search_file="$2"; shift 2;;
    --search-pattern)
      search_pattern="$2"; shift 2;;
    --help|-h)
      echo "Usage: $0 --top-level-folder <dir> --search-folder <folder> --search-file <filename> [--search-pattern <pattern>]"
      exit 0;;
    *)
      echo "Unknown option: $1"; exit 1;;
  esac
done

# ---- Validate required args ----
if [[ -z "$top_level_folder" || -z "$search_folder" || -z "$search_file" ]]; then
  echo "Error: missing required arguments."
  echo "Usage: $0 --top-level-folder <dir> --search-folder <folder> --search-file <filename> [--search-pattern <pattern>]"
  exit 1
fi

# ---- Step 1: Find matching folders ----
mapfile -t found_folders < <(find "$top_level_folder" -type d -name "$search_folder" 2>/dev/null)
if [[ ${#found_folders[@]} -eq 0 ]]; then
  echo "No folders named '$search_folder' found under '$top_level_folder'." >&2
  exit 0
fi

# ---- Step 2: Gather matching files ----
tmpfile=$(mktemp)
for folder in "${found_folders[@]}"; do
  find "$folder" -type f -name "$search_file" -printf "%T@ %p\n" 2>/dev/null >> "$tmpfile"
done

# ---- Step 3: Sort by modification time (newest first) ----
sorted_files=($(sort -nr "$tmpfile" | awk '{ $1=""; sub(/^ /,""); print }'))
rm -f "$tmpfile"

# ---- Step 4: Filter by pattern (if provided) ----
for file in "${sorted_files[@]}"; do
  if [[ -n "$search_pattern" ]]; then
    if grep -qE "$search_pattern" "$file" 2>/dev/null; then
      echo "$file"
    fi
  else
    echo "$file"
  fi
done
