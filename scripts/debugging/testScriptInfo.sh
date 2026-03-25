################################################################################
#
#!/bin/bash
#
################################################################################

# printf "\n##################################################\n"
# printf "Script Name:        %s \n" "${0##*/}"

# printf "Full Path:          %s \n" "$(readlink -f ${BASH_SOURCE[0]})"
# ARGUMENTS=${@}
# printf "Script Arguments:   %s \n" "$ARGUMENTS"
# printf "Path To Script:     %s \n" "${0}     "
# printf "Parent Path:        %s \n" "${0%/*}  "
# printf "##################################################\n\n"


set -euo pipefail
IFS=$'\n\t'

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish 
{
    rm -rf "$scratch"
}

trap finish EXIT

. ./scriptInfo.sh $*