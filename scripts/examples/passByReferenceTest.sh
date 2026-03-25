#!/bin/bash 

source $SCRIPTS/main/functions.sh 

__currentBashVersion="${BASH_VERSION}"
# if echo "${BASH_VERSION}" | grep -q "4.3"; then
#   echo "matched";
# else
# 	printf "This script requires Bash 4.3-alpha or later...you have %s\n" $__currentBashVersion
# 	exit 
# fi

#!/bin/bash
set -x
function pass_back_a_string() {
    eval "$1='foo bar rab oof'"
}

return_var=''
pass_back_a_string return_var
echo $return_var

function call_a_string_func() {
     local lvar=''
     pass_back_a_string lvar
     echo "lvar='$lvar' locally"
}

call_a_string_func
echo "lvar='$lvar' globally"