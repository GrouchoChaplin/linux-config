#-------------------------------------------------------------------------------
# .bashrc
#-------------------------------------------------------------------------------
# set -x 


# Source global definitions
# if [ -f /etc/bashrc ]; then
# 	. /etc/bashrc
# fi


# .bashrc
# Source global definitions
#if [ -f /etc/bashrc ]; then
#       . /etc/bashrc
#fi
for i in /etc/profile.d/*.sh; do
if [ -r "$i" ] && [ "$i" != "/etc/profile.d/tmout.sh" ]; then
    echo "$i"
    if [ "$PS1" ]; then
        . "$i"
    else
        . "$i" >/dev/null
    fi
fi
done
unset i
export TMOUT=0
# echo "################"
echo "TMOUT = ${TMOUT}"
# echo "################"

#	Set Devtools Default to 8
source scl_source enable devtoolset-8

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

shopt -s direxpand
complete -D -o default

#-------------------------------------
export SCRIPTS=~/bin/scripts
#--------------------------------------

#-------------------------------------------------------------------------------
# User Functions
#-------------------------------------------------------------------------------
export FUNCTIONS_SCRIPT=~/bin/scripts/main/functions.sh 
source $FUNCTIONS_SCRIPT

#-------------------------------------------------------------------------------
# ENVIRONMENT 
#-------------------------------------------------------------------------------
export ENVIRONMENT_SCRIPT=~/bin/scripts/main/environment.sh 
source $ENVIRONMENT_SCRIPT

#-------------------------------------------------------------------------------
# User specific aliases and functions
#-------------------------------------------------------------------------------
export ALIASES_SCRIPT=~/bin/scripts/main/aliases.sh
source $ALIASES_SCRIPT

##pringSepLine 80
#printf "Loading .bashrc: %s\n" "$(date)"
##pringSepLine 80

#export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/BASH/bash-history-$(date "+%Y-%m-%d").log; fi'

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="[\u@\h \W]\$(git_branch)\$ "

