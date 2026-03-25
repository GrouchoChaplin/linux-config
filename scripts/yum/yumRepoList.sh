#!/bin/bash 

usage()
{
	__scriptName=${0##*/}
	printf "\nUsage %s \n" "${__scriptName}"
	printf "\t%s-a	List All Repos\n"
	printf "\t%s-d 	List Disabled\n"
	printf "\t%s-e 	List Enabled\n"
	exit 1
}

if [ $# -lt 1 ]; then 
	usage
fi


OPTIND=1
while getopts "ade" opt; do
    case "$opt" in
		a) yum repolist all 	 ;;
		d) yum repolist disabled ;;
		e) yum repolist enabled	 ;;
    esac
done

