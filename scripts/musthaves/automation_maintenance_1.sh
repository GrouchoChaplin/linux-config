#!/bin/bash

# Must-Have Bash Scripts for RHEL 8
# This is a modular collection of functions representing essential automation and maintenance tasks
# for Red Hat Enterprise Linux 8 systems.

# GLOBAL VARIABLES
LOG_DIR="/var/log/custom-scripts"
BACKUP_DIR="/var/backups/system"
UPTIME_THRESHOLD_MINUTES=10080 # 7 days

#######################################
# Create required directories and initialize log file
# Globals:
#   LOG_DIR
# Arguments:
#   None
# Returns:
#   0 if success, 1 on failure
#######################################
init_environment() {
    mkdir -p "$LOG_DIR" || {
        printf "Failed to create log directory at %s\n" "$LOG_DIR" >&2
        return 1
    }
    mkdir -p "$BACKUP_DIR" || {
        printf "Failed to create backup directory at %s\n" "$BACKUP_DIR" >&2
        return 1
    }
    return 0
}

#######################################
# Update all packages with dnf and clean up
# Arguments:
#   None
# Returns:
#   0 if success, 1 on failure
#######################################
system_update() {
    if ! dnf -y update; then
        printf "System update failed\n" >&2
        return 1
    fi

    if ! dnf -y autoremove; then
        printf "Autoremove failed\n" >&2
        return 1
    fi

    if ! dnf clean all; then
        printf "Failed to clean DNF cache\n" >&2
        return 1
    fi
    return 0
}

#######################################
# Create compressed backups of critical system files
# Globals:
#   BACKUP_DIR
# Arguments:
#   None
# Returns:
#   0 if success, 1 on failure
#######################################
backup_system_files() {
    local date_str archive_file
    date_str=$(date +%Y%m%d%H%M%S)
    archive_file="$BACKUP_DIR/sys-backup-$date_str.tar.gz"

    tar -czf "$archive_file" /etc /var/log || {
        printf "Backup failed: unable to archive /etc and /var/log\n" >&2
        return 1
    }

    return 0
}

#######################################
# Check system uptime and warn if exceeds threshold
# Globals:
#   UPTIME_THRESHOLD_MINUTES
# Arguments:
#   None
# Returns:
#   0 if uptime is within threshold, 1 if exceeded
#######################################
check_uptime_threshold() {
    local uptime_minutes
    uptime_minutes=$(awk '{print int($1 / 60)}' /proc/uptime)

    if [[ "$uptime_minutes" -gt "$UPTIME_THRESHOLD_MINUTES" ]]; then
        printf "System uptime exceeds %d minutes. Consider rebooting.\n" "$UPTIME_THRESHOLD_MINUTES" >&2
        return 1
    fi
    return 0
}

#######################################
# Check disk usage and alert if any partition is over 90%
# Arguments:
#   None
# Returns:
#   0 if all filesystems are below threshold, 1 otherwise
#######################################
check_disk_usage() {
    local threshold=90
    local usage_alert

    usage_alert=$(df -h --output=pcent,target | awk 'NR>1 {gsub(/%/,""); if ($1+0 > 90) print $2": "$1"%"}')

    if [[ -n "$usage_alert" ]]; then
        printf "Disk usage alert:\n%s\n" "$usage_alert" >&2
        return 1
    fi
    return 0
}

#######################################
# List all services that failed to start
# Arguments:
#   None
# Returns:
#   0 if none failed, 1 otherwise
#######################################
check_failed_services() {
    local failed
    if ! failed=$(systemctl --failed --no-legend | awk '{print $1}'); then
        printf "Unable to check failed services\n" >&2
        return 1
    fi

    if [[ -n "$failed" ]]; then
        printf "The following services have failed:\n%s\n" "$failed" >&2
        return 1
    fi
    return 0
}

#######################################
# Check for available security updates
# Arguments:
#   None
# Returns:
#   0 if no security updates, 1 if updates available
#######################################
check_security_updates() {
    if ! dnf -q --security check-update > /tmp/sec_updates 2>/dev/null; then
        printf "Security update check failed\n" >&2
        return 1
    fi

    if [[ -s /tmp/sec_updates ]]; then
        printf "Security updates are available:\n" >&2
        cat /tmp/sec_updates >&2
        return 1
    fi
    return 0
}

#######################################
# Main function to orchestrate script flow
# Arguments:
#   None
# Returns:
#   0 if all tasks succeed, 1 otherwise
#######################################
main() {
    if ! init_environment; then
        return 1
    fi

    if ! system_update; then
        return 1
    fi

    if ! backup_system_files; then
        return 1
    fi

    check_uptime_threshold || true
    check_disk_usage || true
    check_failed_services || true
    check_security_updates || true

    return 0
}

main
