#!/bin/bash

# Parse command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --top-level-folder)
            TOP_LEVEL_FOLDER="$2"
            shift 2
            ;;
        --search-folder)
            SEARCH_FOLDER_NAME="$2"
            shift 2
            ;;
        --search-file)
            SEARCH_FILE_NAME="$2"
            shift 2
            ;;
        --search-pattern)
            SEARCH_PATTERN="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required parameters
if [ -z "$TOP_LEVEL_FOLDER" ] || [ -z "$SEARCH_FOLDER_NAME" ] || [ -z "$SEARCH_FILE_NAME" ]; then
    echo "Usage: $0 --top-level-folder <dir> --search-folder <folder_name> --search-file <file_name> [--search-pattern <pattern>]"
    exit 1
fi

# Find all matching files, optionally filter by grep, and sort by modification time (newest first)
find "$TOP_LEVEL_FOLDER" -type d -name "$SEARCH_FOLDER_NAME" -print0 | while IFS= read -r -d '' folder; do
    file_path="$folder/$SEARCH_FILE_NAME"
    if [ -f "$file_path" ]; then
        if [ -n "$SEARCH_PATTERN" ]; then
            if grep -q "$SEARCH_PATTERN" "$file_path"; then
                echo "$file_path"
            fi
        else
            echo "$file_path"
        fi
    fi
done | xargs -0 -I {} stat -c '%Y %n' {} | sort -k1 -n -r | cut -d' ' -f2-