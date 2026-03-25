#!/bin/bash 

if [ "$#" -eq 0 ]; then
	printf "\nUsage: %s <branchtodiff>\n\n" "${0##*/}"
	exit
fi

__branchToDiff="${1}"
git diff "${__branchToDiff}"  origin/"${__branchToDiff}"