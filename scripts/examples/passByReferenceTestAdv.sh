#!/bin/bash 

source $SCRIPTS/main/functions.sh 

__currentBashVersion="${BASH_VERSION}"
if echo "${BASH_VERSION}" | grep -q "4.3"; then
  echo "matched";
else
	printf "This script requires Bash 4.3-alpha or later...you have %s\n" $__currentBashVersion
	exit 
fi

function boo() 
{
    local -n ref=$1
    ref='new' 
}

SOME_VAR='old'
echo $SOME_VAR # -> old
boo SOME_VAR
echo $SOME_VAR # -> new