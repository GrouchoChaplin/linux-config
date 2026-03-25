#!/bin/bash

source $SCRIPTS/utility/utility_functions.sh

__backupLogFilePath="$HOME/.logs/Backups"

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
usage()
{
	__scriptName=${0##*/}
	#pringSepLine
	printf "Usage %s \n" "${__scriptName}"
	printf "\t%s-s  source\n"
	printf "\t%s-d  destination\n"
	printf "\t%s-t  dry-run (optional)\n"
	printf "\t%s-l  log file (optional)\n"
	printf "\t%s-h  this \n"
	#pringSepLine
	exit 1
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
backitup()
{
	local __source="${1}"
	local __destination="${2}"
	local __dryRunOpts="${3}"
	local __logFileName="${4}"
	local __logFilePath="${__backupLogFilePath}""/""${__logFileName}"
	local __verbose="${5}"

	local __logFileOpts=$(printf -- --log-file=)
	if [[ ! -z "${__logFileName// }" ]]; then
		printf -v __logFileOpts "%s%s" "${__logFileOpts}" "${__logFilePath}"

		if [[ -f "${__logFilePath}" ]]; then 
			if (( "${__verbose}" )); then
				rm -vf "${__logFilePath}"	
			else
				rm -f "${__logFilePath}"
			fi
		fi

		__backupDateTime=$(date "+%Y/%m/%d %H:%M:%S")
		#pringSepLine >> "${__logFilePath}"
		if [[ ! -z "${__logFileName// }" ]]; then
			printf "Logfile:      %s\n" "${__logFilePath}" >>  "${__logFilePath}"
		fi
		printf "Date:         %s %s\n" $(date "+%Y/%m/%d %H:%M:%S") >> "${__logFilePath}" 
	 	printf "Source:       %s\n" "${__source}" >> "${__logFilePath}"
	 	printf "Destination:  %s\n" "${__destination}" >> "${__logFilePath}"
	 	#pringSepLine >> "${__logFilePath}"

	fi   

	printf -v __rsyncBaseCmd "rsync %s -hp -avr --keep-dirlinks --links" "${__dryRunOpts}"
	printf -v __rsyncCmd "%s %s %s %s/." "${__rsyncBaseCmd}"  "${__logFileOpts}" "${__source}" "${__destination}" 
	if (( "${__verbose}" )); then
		printf "Executing: %s\n" "${__rsyncCmd}"
	fi

	if [[ ! -z "${__logFileName// }" ]]; then
		printf "Executed: %s\n" "${__rsyncCmd}" >> "${__logFilePath}"
		#pringSepLine >> "${__logFilePath}"
	fi

	eval "${__rsyncCmd}"
}


if [ $# -lt 1 ]; then 
	usage
fi

__source=""
__destination=""
__dryRun=""
__logFile=""
__verbose=0
while getopts ":d:s:tl:hv" Option
do
  case $Option in
    s) 	__source=${OPTARG%/} ;;
    d) 	__destination=${OPTARG%/} ;;
    t) 	__dryRun="--dry-run" ;;
    l) 	__logFile=${OPTARG%/} ;;
	v) __verbose=1 ;;
	h) 	usage ;;
  esac
done
shift $(($OPTIND - 1))


if [[ -z "${__source// }" ]]; then
	printf "ERROR: Source Must Be Specified\n"
	exit 
fi   

if [[ -z "${__destination// }" ]]; then
	printf "ERROR: Destination Must Be Specified\n"
	exit 
fi   

checkDirExists "${__source}"
checkDirExists "${__destination}"

if (( "${__verbose}" )); then
	#pringSepLine
	printf "Source Dir:      %s\n" "${__source}"
	printf "Destination Dir: %s\n" "${__destination}"
	printf "Dry Run:         %s\n" "${__dryRun}"
	printf "Log File:        %s\n" "${__logFile}"
	#pringSepLine
fi 

backitup "${__source}" "${__destination}" "${__dryRun}" "${__logFile}"
