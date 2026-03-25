#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# GLOBAL VARIABLES
SEARCH_DIR=""
OUTPUT_DIR=""

# Ensure required commands exist
require_dependencies() {
    local deps=("find" "mkdir" "cwebp" "convert")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            printf "Error: Required command '%s' not found in PATH.\n" "$dep" >&2
            return 1
        fi
    done
}

# Print usage
print_usage() {
    printf "Usage: %s --search-dir <source_dir> --output-dir <dest_dir>\n" "$0" >&2
}

# Parse input arguments
parse_arguments() {
    if [[ $# -lt 4 ]]; then
        print_usage
        return 1
    fi

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --search-dir)
                shift
                if [[ -z "${1:-}" || "${1:0:1}" == "-" ]]; then
                    printf "Error: Missing argument for --search-dir\n" >&2
                    return 1
                fi
                SEARCH_DIR="$1"
                ;;
            --output-dir)
                shift
                if [[ -z "${1:-}" || "${1:0:1}" == "-" ]]; then
                    printf "Error: Missing argument for --output-dir\n" >&2
                    return 1
                fi
                OUTPUT_DIR="$1"
                ;;
            *)
                printf "Error: Unknown argument '%s'\n" "$1" >&2
                return 1
                ;;
        esac
        shift
    done

    if [[ ! -d "$SEARCH_DIR" ]]; then
        printf "Error: Search directory '%s' does not exist or is not a directory.\n" "$SEARCH_DIR" >&2
        return 1
    fi
}

# Normalize and sanitize absolute paths
sanitize_paths() {
    if ! SEARCH_DIR=$(realpath "$SEARCH_DIR"); then
        printf "Error: Failed to resolve absolute path of search directory.\n" >&2
        return 1
    fi
    if ! OUTPUT_DIR=$(realpath -m "$OUTPUT_DIR"); then
        printf "Error: Failed to resolve absolute path of output directory.\n" >&2
        return 1
    fi

    if [[ "$OUTPUT_DIR" == "$SEARCH_DIR"* ]]; then
        printf "Error: Output directory must not be within the search directory.\n" >&2
        return 1
    fi

    mkdir -p "$OUTPUT_DIR"
}

# Convert single .webp to .jpg
convert_webp_to_jpg() {
    local input="$1"
    local relative_path; relative_path="${input#$SEARCH_DIR/}"
    local output_file="$OUTPUT_DIR/${relative_path%.webp}.jpg"
    local output_dir; output_dir=$(dirname "$output_file")

    mkdir -p "$output_dir"

    if ! convert "$input" "$output_file"; then
        printf "Error: Failed to convert '%s'\n" "$input" >&2
        return 1
    fi
    return 0
}

# Process all .webp files
process_all_webp_files() {
    local webp_files;
    if ! webp_files=$(find "$SEARCH_DIR" -type f -iname "*.webp"); then
        printf "Error: Failed to search for .webp files.\n" >&2
        return 1
    fi

    if [[ -z "$webp_files" ]]; then
        printf "No .webp images found in '%s'\n" "$SEARCH_DIR"
        return 0
    fi

    local success=0
    local failure=0

    while IFS= read -r file; do
        if [[ -z "$file" ]]; then
            continue
        fi
        if convert_webp_to_jpg "$file"; then
            ((success++))
        else
            ((failure++))
        fi
    done <<< "$webp_files"

    printf "Conversion completed: %d succeeded, %d failed.\n" "$success" "$failure"
}

# MAIN FUNCTION
main() {
    require_dependencies || return 1
    parse_arguments "$@" || return 1
    sanitize_paths || return 1
    process_all_webp_files || return 1
}

main "$@"
