#!/bin/bash

source $SCRIPTS/utility/utility_functions.sh

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
usage()
{
	__scriptName=${0##*/}
	printf "Usage %s \n" "${__scriptName}"
	printf "\t%s-l  Local Only Backup\n"
	printf "\t%s-n  Network Only Backup\n"	
	exit 1
}

if [ $# -lt 1 ]; then 
	usage
fi

__networkBackup=0
__localBackup=0

while getopts "nlb" Option
do
  case $Option in

	b)	__networkBackup=1
		__localBackup=1
		;;

    l) 	__localBackup=1
		;;

    n) 	__networkBackup=1 
		;;

  esac
done
shift $(($OPTIND - 1))

__dryRun="${1}"


# Misc 
__backupLogFilePath="$HOME/.logs/Backups/Daily"

#	When Am I backing up
__currentTime=$(date "+%Y_%m_%d_T%H_%M_%S")

# What to backup
__source="${HOME}"/Development

############################################################
# Backup to usb drive
############################################################
if (( "${__localBackup}" )); then 
	printf "Local Backup\n"

	# build log file name for usb drive backup
	printf -v __logFilename "%s/DailyBackup.USBDrive.%s.output" "${__backupLogFilePath}" "${__currentTime}"
	if [[ -f "${__logFilename}" ]]; then 
		rm -vf "${__logFilename}"
	fi
	printf "Local Drive Logfile: %s\n" "${__logFilename}"

	#pringSepLine >> "${__logFilename}"
	printf "Backup Log Path:     %s\n" "${__backupLogFilePath}" >> "${__logFilename}"
	printf "Backup Time:         %s\n" "${__currentTime}" >> "${__logFilename}"
	printf "Backup Source:       %s\n" "${__source}" >> "${__logFilename}"

	# Where to Put it 
	# __destination="${HOME}"/usb-peddycoartte
	__destination=/archive/Backups/Daily
	printf "Backup Destination:  %s\n" "${__destination}" >> "${__logFilename}"

	printf -v __rsyncBaseCmd "rsync %s -hp -avr --keep-dirlinks --links" "${__dryRun}"
	printf "rsync Base Command:  %s\n" "${__rsyncBaseCmd}"

	# Check usb drive mounted
	# if readlink -q "${__destination}" >/dev/null ; then
		__destination="${__destination}"/Backups/Daily/Development
		printf -v __rsyncCmd "%s --log-file=%s %s %s/." "${__rsyncBaseCmd}"  "${__logFilename}" "${__source}" "${__destination}" 
		printf "Excuting: %s\n" "${__rsyncCmd}"
		#pringSepLine >> "${__logFilename}"
		eval "${__rsyncCmd}"
	# else
	# 	echo "${__destination}"": bad link" >> "${__logFilename}"
	#     echo "${__destination}"": bad link" >/dev/stderr
	# fi

fi 


############################################################
# Backup to Z drive
############################################################
if (( "${__networkBackup}" )); then 

	printf "Network Backup\n"

	# build log file name for Z drive backup
	printf -v __logFilename "%s/DailyBackup.ZeeDrive.%s.output" "${__backupLogFilePath}" "${__currentTime}"
	if [[ -f "${__logFilename}" ]]; then 
		rm -vf "${__logFilename}"
	fi
	printf "Z Drive Backup Logfile:   %s\n" "${__logFilename}"

	#pringSepLine >> "${__logFilename}"
	printf "Backup Log Path:     %s\n" "${__backupLogFilePath}" >> "${__logFilename}"
	printf "Backup Time:         %s\n" "${__currentTime}" >> "${__logFilename}"
	printf "Backup Source:       %s\n" "${__source}" >> "${__logFilename}"

	__destination="/z/users/peddycoartte/Backups/Daily/Development/."
	printf "Backup Destination:  %s\n" "${__destination}" >> "${__logFilename}"

	printf -v __rsyncCmd "%s --log-file=%s %s %s/." "${__rsyncBaseCmd}"  "${__logFilename}" "${__source}" "${__destination}" 
	printf "Excuting: %s\n" "${__rsyncCmd}"
	#pringSepLine >> "${__logFilename}"
	eval "${__rsyncCmd}"


	#pringSepLine
	printf "Source File Count: %s\n" $(ls -lR "${HOME}"/Development/AEgisDI2ERepos | wc -l)
	printf "USB File Count:    %s\n" $(ls -lR "${HOME}"/usb-peddycoartte/Backups/Daily/Development/AEgisDI2ERepos | wc -l)
	printf "Z File Count:      %s\n" $(ls -lR /z/users/peddycoartte/Backups/Daily/Development/AEgisDI2ERepos | wc -l)
	#pringSepLine

fi 
