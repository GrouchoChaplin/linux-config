#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish 
{
    rm -rf "$scratch"
}

trap finish EXIT

function usage() 
{ 
	printf "%s\n" "-------------------------------------------------------"
	printf "Script Name: %s \n" "${0##*/}"
	printf "Description: Search specfified path for git repos and report status of same\n"
	printf "Usage: %s -s searchPath -o outputFile -v \n" "$0" 1>&2; 
	printf "\n"
	printf "    -s searchPath:  Path to search for repos\n"
	printf "\n"
	printf "    -o outputFile:  Redirect output to this file....\n"
	printf "\n"
	printf "    -v:             Print additional script info\n"
	printf "\n"
	printf "    -h:             Help... this.\n"
	printf "\n"
	printf "%s\n" "-------------------------------------------------------"

	exit 1; 
}

if [ $# -lt 1 ]; then 
	usage
fi

# searchPath=${1:-$PWD}
# outputFile=${2:-""}
# verbose=0

TIME=$(date "+%H:%M:%S")
NOW=$(date "+%Y_%m_%d_T%H_%M_%S")
TODAY=$(date "+%Y-%m-%d")

options=""
searchPath=""
outputFile=""
verbose=0
while getopts ":s:o:hv" Option
do
  case $Option in
  	o) outputFile=${OPTARG}		;;
    s) searchPath=${OPTARG%/}	;;
	v) verbose=1				;;
	h) usage 					;;
  esac
done
shift $(($OPTIND - 1))


if [[ -z "${searchPath// }" ]] ; then

	printf "\n################################################################\n"
	printf "# %s ERROR: You must specify SEARCH PATH #\n" "$0"
	printf "################################################################\n\n"
	exit
fi


if [ -n "$outputFile" ]; then
	printf "Save stdout and stderr to file descriptors 3 and 4, then redirect them to %s\n" "$outputFile"
	exec 3>&1 4>&2 >$outputFile 2>&1
fi

printf "Search Path: %s\n" "${searchPath}"
printf "Output File: %s\n" "${outputFile}"
printf "Verbose:     %d\n" "${verbose}"

if (( verbose )); then
	echo "Search Path: $searchPath"
	. "$SCRIPTS"/scriptInfo.sh $*
	printf "\n\nFind git repos:\n\n"
fi

currentDir=$PWD
for repo in `find $searchPath -type d -name .git`
do
	dir=`echo ${repo} | sed -e 's/\/.git/\//'`
 	url=$(cat $dir/.git/config | awk /'url =/ {print $3}')

 	printf "#######################################################\n"
	currentDir=$PWD
	cd $dir
	printf "Repo: %s URL: %s\n\n" "$dir" "$url"
	printf "Status: \n\n"
	git status
	cd $currentDir
 	printf "\n#######################################################\n"

done

if [ -n "$outputFile" ]; then
	exec 1>&3 2>&4
	printf "Restore stdout and stderr\n"
	cat $outputFile
fi

