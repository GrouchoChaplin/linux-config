#!/bin/env bash

searchPath=${1:-"."}
searchBranch=${2}

# if [[ -z "$searchPath" ]]; then

# 	printf "\n\nNo search path specified...exiting\n\n"
# 	exit
# fi


if [[ -z "$searchBranch" ]]; then

	printf "\n\nNo branch, or sub-name specified...exiting\n\n"
	exit
fi

printf "\n\nSearching for repo with branch %s \n\n" "$searchBranch"

printf "Your Specified Search Path: %s Continue? [y] " "$searchPath"
read proceed
if [[ ($proceed = "n" || $proceed = "N") ]]; then
	exit
fi 

printf "\n\nFind git repos:\n\n"
for repo in `find $searchPath -type d -name ".git"`
do
	dir=`echo ${repo} | sed -e 's/\/.git/\//'`
	printf "Found repo: %s\n" "$dir"
    cd ${dir}
    git branch -l |grep $2
   	cd - &> /dev/null
done

printf "\n\nFINISHED\n\n"


