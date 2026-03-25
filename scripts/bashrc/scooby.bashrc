#-------------------------------------------------------------------------------
# .bashrc
#-------------------------------------------------------------------------------

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# #pringSepLine 80
# printf "Loading .bashrc: %s\n" "$(date)"
# #pringSepLine 80
#-------------------------------------
export SCRIPTS=~/CodeFromRepo/AEgis/Ed-Peddycoart/scripts

#--------------------------------------

#-------------------------------------------------------------------------------
# User specific aliases and functions
#-------------------------------------------------------------------------------
export ALIASES_SCRIPT=~/bin/scripts/aliases.sh
#. ~/bin/scripts/aliases.sh
. $ALIASES_SCRIPT

#-------------------------------------------------------------------------------
# User Functions
#-------------------------------------------------------------------------------
export FUNCTIONS_SCRIPT=~/bin/scripts/functions.sh 
#. ~/bin/scripts/functions.sh 
. $FUNCTIONS_SCRIPT

#-------------------------------------------------------------------------------
# ENVIRONMENT 
#-------------------------------------------------------------------------------
export ENVIRONMENT_SCRIPT=~/bin/scripts/environment.sh 
. $ENVIRONMENT_SCRIPT

export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'

export __GL_SYNC_TO_VBLANK="0"



export FLT2_BIN_DIR="/home/epeddycoart/Software/flites/flites-2.0-r1045/binaries/linux_x64_gcc_4_4_7/bin"

export FLT2_LIBRARY_DIR="/home/epeddycoart/Software/flites/flites-2.0-r1045/binaries/linux_x64_gcc_4_4_7/lib"

export PATH="/home/epeddycoart/Software/flites/flites-2.0-r1045/binaries/linux_x64_gcc_4_4_7/bin:$PATH"

export LD_LIBRARY_PATH="/home/epeddycoart/Software/flites/flites-2.0-r1045/binaries/linux_x64_gcc_4_4_7/lib:$LD_LIBRARY_PATH"

export MANPATH="/home/epeddycoart/Software/flites/flites-2.0-r1045:$MANPATH"



export FLT2_DIR="/home/epeddycoart/Software/flites/flites-2.0-r1045"
#source /home/epeddycoart/.jsig/jsig.env
