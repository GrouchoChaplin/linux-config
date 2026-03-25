################################################################################
#                                                                              #
#!/bin/bash                                                                    #
#                                                                              #
################################################################################
################################################################################
#                                                                              #
#  script: testStatusMesssages.sh 
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

. statusMessages.sh

trap finish EXIT

printStatus "STATUS"
printWarning "WARNING"
printError "ERROR"

