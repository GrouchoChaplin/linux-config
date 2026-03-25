#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# === Function to validate and resolve directory ===
resolve_directory() {
    local input="$1"
    local abs_path

    if [[ -z "${input// }" ]]; then
        printf "Error: Directory path is empty\n" >&2
        return 1
    fi

    if [[ "$input" != /* ]]; then
        input="$(pwd)/$input"
    fi

    abs_path=$(readlink -f "$input" 2>/dev/null) || {
        printf "Error: Invalid directory path: %s\n" "$input" >&2
        return 1
    }

    if [[ ! -d "$abs_path" ]]; then
        printf "Error: Not a directory: %s\n" "$abs_path" >&2
        return 1
    fi

    printf "%s\n" "$abs_path"
}

# === Function to list size of each subdirectory ===
list_subfolder_sizes() {
    local dir="$1"
    local target_dir; target_dir=$(resolve_directory "$dir") || return 1

    if ! du -sh -- "${target_dir}"/*/ 2>/dev/null; then
        printf "No subdirectories found in: %s\n" "$target_dir" >&2
        return 1
    fi
}

# === Main Entry Point ===
main() {
    if [[ $# -ne 1 ]]; then
        printf "Usage: %s <directory>\n" "$0" >&2
        return 1
    fi

    list_subfolder_sizes "$1"
}

main "$@"
