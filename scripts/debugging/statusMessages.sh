################################################################################
#                                                                              #
#!/bin/bash                                                                    #
#                                                                              #
################################################################################
################################################################################
#                                                                              #
#  script: statusMesssages.sh 
#                                                                              #
#  Description:                                                                #
#                                                                              #
#                                                                              #
################################################################################

set -euo pipefail
IFS=$'\n\t'

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish 
{
  	rm -rf "$scratch"
}

Black=0
Red=1
Green=2
Yellow=3
Blue=4
Magenta=5
Cyan=6
White=7
Default=9

trap finish EXIT

#---------------------------------------------------------------------
#
#---------------------------------------------------------------------
printMessage ()
{
	local defaultMessage="No message passed."
	message=${1:-$defaultMessage}

	fg_color=${2:-$Default}
	set_foreground=$(tput setaf $fg_color)

	bg_color=${3:-$Default}
	set_background=$(tput setab $bg_color)

	echo -n $set_background$set_foreground
	printf ' %s ' $message
	echo $(tput sgr0)
}

#---------------------------------------------------------------------
#
#---------------------------------------------------------------------
printStatus ()
{
 	local defaultMessage="STATUS: No message passed."

	message=${1:-$defaultMessage}

	printMessage $message $Default $Default
	tput sgr0
}

#---------------------------------------------------------------------
#
#---------------------------------------------------------------------
printError ()
{
 	local defaultMessage="ERROR: No message passed."

	message=${1:-$defaultMessage}

	tput bold
	printMessage $message $Red $Black
	tput sgr0
}

#---------------------------------------------------------------------
#
#---------------------------------------------------------------------
printWarning ()
{
 	local defaultMessage="WARNING: No message passed."

	message=${1:-$defaultMessage}

	tput bold
	printMessage $message $Yellow $Black
	tput sgr0
}
