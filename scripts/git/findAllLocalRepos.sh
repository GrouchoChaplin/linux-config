#!/bin/env bash

# searchPath=${1:-"."}

# printf "Your Specified Search Path: %s Continue? [y] " "$searchPath"
# read proceed
# if [[ ($proceed = "n" || $proceed = "N") ]]; then
# 	exit
# fi 

# printf "\n\nFind git repos:\n\n"
for repo in `find . -type d -name ".git"`
do
	dir=`echo ${repo} | sed -e 's/\/.git/\//'`
	printf "Found repo: %s\n" "$dir"
done

# printf "\n\nFINISHED\n\n"


