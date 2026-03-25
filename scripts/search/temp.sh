#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Global Variables
SEARCH_FILENAME="$1"
SEARCH_DEPTH="${2:-}"
TOP_N="${3:-5}"
SEARCH_DIRS=("/mnt" "/media" "/data" "/disk" "/srv")

# Ensure all outputs are sorted by modification time descending
# Usage: get_top_n_matches "/path/to/search" "filename.ext" 10
get_top_n_matches() {
    local root_dir="$1"
    local filename="$2"
    local top_n="$3"
    local depth_option

    if [[ -n "$SEARCH_DEPTH" && "$SEARCH_DEPTH" =~ ^[0-9]+$ ]]; then
        depth_option=(-maxdepth "$SEARCH_DEPTH")
    else
        depth_option=()
    fi

    find "$root_dir" "${depth_option[@]}" -type f -name "$filename" -printf "%T@ %p\n" 2>/dev/null |
        sort -nr |
        head -n "$top_n"
}

# Collect all results from all mount points
aggregate_results() {
    local filename="$1"
    local top_n="$2"
    local tmpfile
    tmpfile=$(mktemp)

    for dir in "${SEARCH_DIRS[@]}"; do
        if [[ -d "$dir" ]]; then
            if ! get_top_n_matches "$dir" "$filename" "$top_n" >>"$tmpfile"; then
                printf "Failed to search in %s\n" "$dir" >&2
            fi
        fi
    done

    if [[ ! -s "$tmpfile" ]]; then
        printf "No matching files found.\n" >&2
        rm -f "$tmpfile"
        return 1
    fi

    sort -nr "$tmpfile" | head -n "$top_n" | cut -d' ' -f2-
    rm -f "$tmpfile"
}

main() {
    if [[ -z "$SEARCH_FILENAME" || "$SEARCH_FILENAME" =~ [[:space:]] ]]; then
        printf "Invalid filename argument.\n" >&2
        return 1
    fi

    if ! [[ "$TOP_N" =~ ^[0-9]+$ ]]; then
        printf "Invalid number for top N: %s\n" "$TOP_N" >&2
        return 1
    fi

    if ! aggregate_results "$SEARCH_FILENAME" "$TOP_N"; then
        return 1
    fi
}

main "$@"
