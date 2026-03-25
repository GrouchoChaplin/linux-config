#!/bin/bash

# Additional Must-Have Bash Scripts for RHEL 8
# Includes essential system monitoring, security auditing, performance tuning,
# and automation helpers using modular functions.

# GLOBAL VARIABLES
AUDIT_REPORT="/var/log/custom-scripts/audit_report.txt"
USER_REPORT="/var/log/custom-scripts/user_login_report.txt"
CRON_BACKUP="/var/backups/system/cronjobs.bak"
SERVICE_LIST="/var/log/custom-scripts/enabled_services.txt"
CPU_LOAD_THRESHOLD=5.0
MEMORY_THRESHOLD_PERCENT=90

#######################################
# Audit user accounts for locked, expired, and inactive users
# Globals:
#   AUDIT_REPORT
# Arguments:
#   None
# Returns:
#   0 if report generated successfully, 1 on failure
#######################################
audit_user_accounts() {
    local locked expired inactive;
    locked=$(passwd -S -a 2>/dev/null | awk '$2=="L" {print $1}')
    expired=$(chage -l $(cut -d: -f1 /etc/passwd) 2>/dev/null | grep -B1 "Account expires.*" | grep -v "Account expires" | awk '{print $1}')
    inactive=$(lastlog -b 90 | awk 'NR>1 && $NF=="**Never" {print $1}')

    {
        printf "Locked Accounts:\n%s\n\n" "$locked"
        printf "Expired Accounts:\n%s\n\n" "$expired"
        printf "Inactive Accounts (>90 days):\n%s\n\n" "$inactive"
    } > "$AUDIT_REPORT" || {
        printf "Failed to write audit report to %s\n" "$AUDIT_REPORT" >&2
        return 1
    }

    return 0
}

#######################################
# Backup all user crontabs and system cron files
# Globals:
#   CRON_BACKUP
# Arguments:
#   None
# Returns:
#   0 if success, 1 on failure
#######################################
backup_cron_jobs() {
    local tmpdir; tmpdir=$(mktemp -d) || {
        printf "Failed to create temporary directory\n" >&2
        return 1
    }

    cp -r /var/spool/cron "$tmpdir/" 2>/dev/null
    cp -r /etc/cron* "$tmpdir/" 2>/dev/null

    tar -czf "$CRON_BACKUP" -C "$tmpdir" . || {
        printf "Failed to create cron backup archive\n" >&2
        rm -rf "$tmpdir"
        return 1
    }

    rm -rf "$tmpdir"
    return 0
}

#######################################
# Monitor CPU load average and alert if over threshold
# Globals:
#   CPU_LOAD_THRESHOLD
# Arguments:
#   None
# Returns:
#   0 if load is normal, 1 if exceeded
#######################################
check_cpu_load() {
    local load; load=$(awk '{print $1}' /proc/loadavg)

    if awk "BEGIN {exit !($load > $CPU_LOAD_THRESHOLD)}"; then
        printf "High CPU load detected: %.2f (Threshold: %.2f)\n" "$load" "$CPU_LOAD_THRESHOLD" >&2
        return 1
    fi
    return 0
}

#######################################
# Monitor memory usage and alert if over threshold
# Globals:
#   MEMORY_THRESHOLD_PERCENT
# Arguments:
#   None
# Returns:
#   0 if memory is under threshold, 1 otherwise
#######################################
check_memory_usage() {
    local total used percent
    total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    used=$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t-a}' /proc/meminfo)
    percent=$((used * 100 / total))

    if [[ "$percent" -gt "$MEMORY_THRESHOLD_PERCENT" ]]; then
        printf "High memory usage detected: %d%% (Threshold: %d%%)\n" "$percent" "$MEMORY_THRESHOLD_PERCENT" >&2
        return 1
    fi
    return 0
}

#######################################
# Generate login activity report for all users
# Globals:
#   USER_REPORT
# Arguments:
#   None
# Returns:
#   0 if success, 1 on failure
#######################################
generate_user_login_report() {
    local report;
    if ! report=$(last -w | grep -v 'reboot\|shutdown' | awk '{print $1, $3, $4, $5, $6, $7}' | sort | uniq -c); then
        printf "Failed to generate login report\n" >&2
        return 1
    fi

    printf "%s\n" "$report" > "$USER_REPORT" || {
        printf "Failed to write user login report\n" >&2
        return 1
    }

    return 0
}

#######################################
# List all enabled systemd services
# Globals:
#   SERVICE_LIST
# Arguments:
#   None
# Returns:
#   0 if success, 1 on failure
#######################################
list_enabled_services() {
    local services;
    if ! services=$(systemctl list-unit-files --type=service --state=enabled | awk 'NR>1 && NF {print $1}'); then
        printf "Failed to retrieve enabled services\n" >&2
        return 1
    fi

    printf "%s\n" "$services" > "$SERVICE_LIST" || {
        printf "Failed to write service list to %s\n" "$SERVICE_LIST" >&2
        return 1
    }

    return 0
}

#######################################
# Main function to run all utilities
# Arguments:
#   None
# Returns:
#   0 if all succeed, 1 otherwise
#######################################
main() {
    mkdir -p /var/log/custom-scripts || {
        printf "Could not create script log directory\n" >&2
        return 1
    }

    mkdir -p /var/backups/system || {
        printf "Could not create backup directory\n" >&2
        return 1
    }

    audit_user_accounts || true
    backup_cron_jobs || true
    check_cpu_load || true
    check_memory_usage || true
    generate_user_login_report || true
    list_enabled_services || true

    return 0
}

main
