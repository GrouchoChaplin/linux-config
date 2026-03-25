#!/bin/env bash

searchPath=${1:-"."}
searchTerm=${2:-"VolumeDatabase*"}

outputFilename=`echo ${searchPath} | sed 's/\//_/g'`
fileSuffix=`echo ${outputFilename} | sed 's/\_home_peddycoartte_//g'`
outputFilename=${HOME}/"${searchTerm}_FoundIn_${fileSuffix}.txt"

echo "Your Specified Search Path: ${searchPath}" 2>&1 | tee "${outputFilename}"
echo "Your Specified Search Term: ${searchTerm}" 2>&1 | tee -a "${outputFilename}"
echo "Output Filename:            ${outputFilename}" 2>&1 | tee -a "${outputFilename}"

: <<'END_COMMENT'
END_COMMENT

#	Find a folder than contains a repo
for repoFolder in `find $searchPath -type d -name ".git"`
do

	# Get Git URL
	gitConfigFile="$repoFolder/config"
	gitUrl=$(grep -i jsig.git ${gitConfigFile})

	# If it is a jsig repo
	if grep -iq "jsig.git" <<< ${gitUrl}; then
		echo "########################################" 2>&1 | tee -a "${outputFilename}"
		projectDir=`echo ${repoFolder} | sed -e 's/\/.git/\//'`
		echo "Project Dir:     ${projectDir}" 2>&1 | tee -a "${outputFilename}"
		echo "Repo Folder:     ${repoFolder}" 2>&1 | tee -a "${outputFilename}"
		echo "Git Config File: ${gitConfigFile}" 2>&1 | tee -a "${outputFilename}"
		echo "Git URL:         ${gitUrl}" 2>&1 | tee -a "${outputFilename}"

    	pushd ${projectDir} > /dev/null
			${HOME}/bin/git-find-file -vcd $searchTerm 2>&1 | tee -a "${outputFilename}"
   		popd > /dev/null
		echo "########################################"
	fi 

done


printf "\n\nFINISHED\n\n"

