#!/bin/bash

__scripToRun="${1}"

if [ -n "$__scripToRun" ]; 
then

	__timeStamp=$(date "+%Y_%m_%d_T%H_%M_%S")

	printf -v outputFile "%s.%s.output" "${__scripToRun}" "${__timeStamp}"

	if [[ -f "${outputFile}" ]]; then 
		rm -vf "${outputFile}"
	fi

	printf "Save stdout and stderr to file descriptors 3 and 4, then redirect them to %s\n" "${outputFile}"

	exec 3>&1 4>&2 >$outputFile 2>&1

	 	source "${__scripToRun}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}" "${10}" "${11}" 

	exec 1>&3 2>&4

	printf "Restore stdout and stderr\n"

fi

cat $outputFile