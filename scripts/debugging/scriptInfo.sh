################################################################################
#
#!/bin/bash
#
################################################################################
set -euo pipefail
IFS=$'\n\t'

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish 
{
    rm -rf "$scratch"
}

trap finish EXIT


# #---------------------------------------------------------------------
# #
# #---------------------------------------------------------------------
# function scriptInfo () 
# {
	printf "************************************************************\n"
	printf "Hostname:       %s\n" ${HOSTNAME}
	printf "Script name:    %s\n" "${0##*/}"
	printf "Arguments:      %s\n" "$@"
	printf "Path To Script: %s\n" "${0}"
	printf "Parent Path:    %s\n" "${0%/*}"
	printf "Script PID:     %s\n" "$$"
	printf "Script Dir:     %s\n" "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	printf "************************************************************\n"
# }
#scriptInfo $*