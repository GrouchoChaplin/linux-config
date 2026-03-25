#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# === Global Variables ===
SRC_INPUT=""
DST_INPUT=""
ABS_SRC=""
ABS_DST=""
VERBOSE=0

# === Function to display usage information ===
print_help() {
    printf "\nUsage:\n"
    printf "  %s --src <source_dir> --dst <destination_dir> [--verbose] [--help]\n\n" "$0"
    printf "Options:\n"
    printf "  --src       Directory to back up (required)\n"
    printf "  --dst       Destination directory for backup (required)\n"
    printf "  --verbose   Show rsync progress output\n"
    printf "  --help      Display this help message\n\n"
    return 0
}

# === Function to sanitize and get absolute path ===
get_abs_path() {
    local input_path="$1"
    local abs_path

    if [[ -z "${input_path// }" ]]; then
        printf "Empty path provided\n" >&2
        return 1
    fi

    if [[ "$input_path" == /* ]]; then
        abs_path="$input_path"
    else
        abs_path="$(pwd)/$input_path"
    fi

    abs_path=$(readlink -f "$abs_path" 2>/dev/null) || {
        printf "Invalid path: %s\n" "$input_path" >&2
        return 1
    }

    printf "%s\n" "$abs_path"
}

# === Function to parse script arguments ===
parse_args() {
    local arg

    while [[ $# -gt 0 ]]; do
        arg="$1"
        case "$arg" in
            --src)
                shift
                [[ $# -eq 0 ]] && { printf "--src requires a value\n" >&2; return 1; }
                SRC_INPUT="$1"
                ;;
            --dst)
                shift
                [[ $# -eq 0 ]] && { printf "--dst requires a value\n" >&2; return 1; }
                DST_INPUT="$1"
                ;;
            --verbose)
                VERBOSE=1
                ;;
            --help)
                print_help
                exit 0
                ;;
            *)
                printf "Unknown argument: %s\n" "$arg" >&2
                return 1
                ;;
        esac
        shift
    done

    if [[ -z "${SRC_INPUT// }" || -z "${DST_INPUT// }" ]]; then
        printf "Both --src and --dst are required\n" >&2
        return 1
    fi
}

# === Function to verify rsync dependency ===
check_dependencies() {
    if ! command -v rsync >/dev/null; then
        printf "rsync is not installed or not in PATH\n" >&2
        return 1
    fi
}

# === Function to run rsync preserving full source folder ===
run_backup() {
    local src_name; src_name=$(basename "$ABS_SRC")
    local target_path="$ABS_DST/$src_name"
    local rsync_flags=(-a --delete --numeric-ids --inplace --links)

    (( VERBOSE == 1 )) && rsync_flags+=(-v --progress)

    mkdir -p "$ABS_DST"

    if ! rsync "${rsync_flags[@]}" "$ABS_SRC" "$ABS_DST/"; then
        printf "rsync failed to copy %s to %s\n" "$ABS_SRC" "$ABS_DST" >&2
        return 1
    fi

    printf "Backup completed: %s\n" "$target_path"
}

# === Main Entry Point ===
main() {
    parse_args "$@" || { print_help; return 1; }
    check_dependencies || return 1

    ABS_SRC=$(get_abs_path "$SRC_INPUT") || return 1
    ABS_DST=$(get_abs_path "$DST_INPUT") || return 1

    if [[ ! -d "$ABS_SRC" ]]; then
        printf "Source directory does not exist: %s\n" "$ABS_SRC" >&2
        return 1
    fi

    run_backup || return 1
}

main "$@"
