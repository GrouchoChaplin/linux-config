#!/bin/bash                                                                    #

function genDateTag()
{
	currentDate=$(date "+%Y_%m_%d")
	echo  $currentDate
}

export dirToTar="${1}"
echo "Dir To Tar:       " "${dirToTar}"

export tarFileName="${dirToTar}"."$(genDateTag)".tar.gz
echo "Tar Filename:     " "${tarFileName}"

export tarFilePartialName="${tarFileName}"".part"
echo "Tar Partial Name: " "${tarFilePartialName}"

export sizeLimit="${2:-4000M}"
echo "Size Limit:       " "${sizeLimit}"

tar cvzf "${tarFileName}" "${dirToTar}"

split -b "${sizeLimit}" "${tarFileName}" "${tarFilePartialName}"
 
cat "${tarFileName}".parta* >backup.tar.gz.joined