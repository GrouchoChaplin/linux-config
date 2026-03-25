#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Global variables
SOURCE_DIR="$1"
BACKUP_DIR="$2"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"

# Trap signals for graceful exit
trap 'handle_exit' INT TERM ERR

handle_exit() {
    printf "Script terminated unexpectedly.\n" >&2
    return 1
}

sanitize_input() {
    local input="$1"

    if [[ -z "$input" || "$input" =~ [[:space:]] ]]; then
        printf "Invalid input: '%s'\n" "$input" >&2
        return 1
    fi

    if [[ ! -d "$input" ]]; then
        printf "Directory does not exist: %s\n" "$input" >&2
        return 1
    fi
}

create_backup_dir() {
    mkdir -p "$BACKUP_DIR"
}

generate_backup() {
    local archive_path="${BACKUP_DIR}/${ARCHIVE_NAME}"

    if ! tar -czf "$archive_path" -C "$SOURCE_DIR" .; then
        printf "Failed to create backup archive: %s\n" "$archive_path" >&2
        return 1
    fi

    if [[ ! -s "$archive_path" ]]; then
        printf "Backup archive is empty: %s\n" "$archive_path" >&2
        return 1
    fi

    printf "Backup created: %s\n" "$archive_path"
}

verify_arguments() {
    if [[ $# -ne 2 ]]; then
        printf "Usage: %s <source_directory> <backup_directory>\n" "$0" >&2
        return 1
    fi
}

main() {
    verify_arguments "$@" || return 1

    sanitize_input "$SOURCE_DIR" || return 1
    sanitize_input "$BACKUP_DIR" || return 1

    create_backup_dir || return 1

    generate_backup || return 1
}

main "$@"
