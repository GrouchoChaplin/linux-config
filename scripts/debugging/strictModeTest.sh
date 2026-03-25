################################################################################
#                                                                              #
#!/bin/bash                                                                    #
#                                                                              #
################################################################################
################################################################################
#                                                                              #
#  	script: strictModeTest.sh                                                  #
#                                                                              #
#  	Description:                                                               #
#                                                                              #
# 	source: http://redsymbol.net/articles/unofficial-bash-strict-mode/         #
#                                                                              #
################################################################################

set -euo pipefail
IFS=$'\n\t'

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish 
{
	printf "Function: %s\n\n" "$FUNCNAME"
  	rm -rf "$scratch"
}

trap finish EXIT


