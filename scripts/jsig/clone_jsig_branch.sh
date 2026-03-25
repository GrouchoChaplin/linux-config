#!/bin/env bash 



__JSIGTarget="jsig"
__branch=""
__branchArgs=""

if ! options=$(getopt -o f:b: -l folder:,branch: -- "$@")
then
    # something went wrong, getopt will put out an error message for us
    exit 1
fi

eval set -- $options

while [ $# -gt 0 ]
do
    case $1 in

        -f|--folder)
            __JSIGTarget="$2"
            shift;;

        -b|--branch)
            __branch="$2"
            shift;;

        (--) shift; break;;
        (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
        (*) break;;
    esac
    shift
done


printf "Clone JSIG branch %s to %s\n" "${__branch}" "${__JSIGTarget}"


 if [[ ! -z "${__branch}" ]]
 then
    printf -v __gitCommand "git clone https://gitlab.bluehalo.com/jsig/jsig.git \055-verbose \055-branch %s  \055-single-branch %s" "${__branch}" "${__JSIGTarget}"
 else
    printf -v __gitCommand "git clone https://gitlab.bluehalo.com/jsig/jsig.git \055-verbose %s" "${__JSIGTarget}"
 fi

echo "Executing: ""${__gitCommand}"

__start="$(date +%s)"
echo "Start: ${__start}"

echo "Executing: ""${__gitCommand}"
eval "${__gitCommand}"

__end="$(date +%s)"

echo "End: ${__end}"

__duration=$[ ${__end} - ${__start} ]
echo "Cloning duration: ${__duration}"
