#!/bin/bash 

#
# Implementing suggestions from "Using Use the Unofficial Bash Strict Mode"
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
#

#  The set -e option instructs bash to immediately exit if any 
#  command has a non-zero exit status. 
set -e

#  When set, a reference to any variable you haven't previously defined 
#  - with the exceptions of $* and $@ - is an error, and causes the program 
#  to immediately exit.
# set -u

#  This setting prevents errors in a pipeline from being masked. If any
#  command in a pipeline fails, that return code will be used as the 
#  return code of the whole pipeline. By default, the pipeline's return 
#  code is that of the last command - even if it succeeds.
set -o pipefail


scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish {

  rm -rf "$scratch"
}
trap finish EXIT

# Now your script can write files in the directory "$scratch".
# It will automatically be deleted on exit, whether that's due
# to an error, or normal completion.


__scriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


#---------------------------------------------------------------------
#
#---------------------------------------------------------------------
function #pringSepLine()
{
    sepLength=$1
    if [[ -z "${sepLength// }" ]]; then
        sepLength=80
    fi   
    printf '%.0s-' $(seq 1 $sepLength)
    printf "\n"
}

#---------------------------------------------------------------------
#
#---------------------------------------------------------------------
function printEnvVar() 
{
    __envVariableName="${1}"
    echo "$__envVariableName = ${!__envVariableName}"
}

#---------------------------------------------------------------------
#
#---------------------------------------------------------------------
function diagnosticInfo () 
{
    printf "**************************************************\n"
    arguments=( "$0" "$@" )
    printf "Host:           %s\n" "${HOSTNAME}"
    printf "Script Name:    %s\n" "${0##*/}"
    printf "Arguments:      %s\n" "${*}"
    printf "Path-To-Script: %s\n" "${0}"
    printf "Parent Path:    %s\n" "${0%/*}"
    printf "Arguments:\n"
    for ((idx=1; idx<${#arguments[@]}; ++idx)); do
        printf "  \$%s:           %s\n" "$idx" "${arguments[idx]}"
    done
    printf "Script PID:     %s\n" "$$"
    printf "__scriptDir:    %s\n" "${__scriptDir}"
    printf  "**************************************************\n"
}

printf "LINE:  %s\n" ${LINENO}
diagnosticInfo "${@}"
printf "LINE:  %s\n" ${LINENO}
