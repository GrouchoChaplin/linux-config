#!/bin/bash

# Force-run a cronjob manually to verify correctness
# This script mimics how cron runs your job by replicating the environment

# GLOBALS
CRON_USER="peddycoartte"
CRON_SCHEDULE="/etc/cron.d"
CRON_COMMAND="/home/peddycoartte/bin/scripts/backup/nightly_backup.sh"
CRON_LOG="/var/log/cron_forced_run.log"

#######################################
# Run a command as if it were run by cron
# Globals:
#   CRON_USER
#   CRON_COMMAND
#   CRON_LOG
# Arguments:
#   None
# Returns:
#   0 if success, 1 if command fails
#######################################
run_as_cron() {
    local output;
    if ! output=$(sudo -u "$CRON_USER" env -i \
        PATH="/usr/bin:/bin:/usr/sbin:/sbin" \
        SHELL=/bin/bash \
        HOME="/home/$CRON_USER" \
        "$CRON_COMMAND" 2>&1); then
        printf "[%s] CRON SIMULATION FAILED\n%s\n" "$(date)" "$output" >> "$CRON_LOG"
        return 1
    fi

    printf "[%s] CRON SIMULATION SUCCEEDED\n%s\n" "$(date)" "$output" >> "$CRON_LOG"
    return 0
}

#######################################
# Validate cron command path
# Globals:
#   CRON_COMMAND
# Arguments:
#   None
# Returns:
#   0 if exists and executable, 1 otherwise
#######################################
validate_cron_command() {
    if [[ ! -x "$CRON_COMMAND" ]]; then
        printf "Cron command does not exist or is not executable: %s\n" "$CRON_COMMAND" >&2
        return 1
    fi
    return 0
}

#######################################
# Main function
# Arguments:
#   None
# Returns:
#   0 on success, 1 otherwise
#######################################
main() {
    if ! validate_cron_command; then
        return 1
    fi

    if ! run_as_cron; then
        printf "Forced cronjob execution failed. Check log: %s\n" "$CRON_LOG" >&2
        return 1
    fi

    printf "Forced cronjob executed successfully. See log: %s\n" "$CRON_LOG"
    return 0
}

main
