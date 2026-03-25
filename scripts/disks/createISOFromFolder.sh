#!/bin/bash

#	Get folder
__targetFolder=${1:?"Specify Target Folder As Argument 1"}

#	Get iso filename
__isoFilename="${__targetFolder}"".iso"

#	Get mount point 
__mountPoint=${2}

printf "Target Folder: %s\n" "${__targetFolder}"
printf "ISO Filename:  %s\n" "${__isoFilename}"
if [ ! -z ${__mountPoint} ]; then 
	printf "Mount Point:   %s\n" "${__mountPoint}"
 fi

if [[ -f "${__isoFilename}" ]]; then
	printf "%s already exists.... Delete [y]\n" "${__isoFilename}"
	read response
	if [ "$response" = "n" ]; then
		exit
	fi 
	rm -rfv "${__isoFilename}"
	printf "\n"
fi

printf "Creating %s from %s\n" "${__isoFilename}" "${__targetFolder}"

mkisofs -iso-level 3 -J -joliet-long -rock -input-charset utf-8 -o  "${__isoFilename}" "${__targetFolder}"

if [ ! -z ${__mountPoint} ]; then 
	#	Mount to check
	sudo umount "${__mountPoint}"
	sudo mount -o loop "${__isoFilename}" "${__mountPoint}"
	ls -ls "${__mountPoint}"
 fi
