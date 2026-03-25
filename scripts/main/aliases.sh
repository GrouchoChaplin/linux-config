#!/bin/bash

##pringSepLine 80
printf "Setting Aliases: %s\n" "$(date)"
##pringSepLine 80

alias sublime='subl'

#alias clion='$HOME/Software/clion-2022.2.1/bin/clion.sh'

alias clion='$HOME/Software/clion-2022.3/bin/clion.sh'

#-------------------------------------------------------------------------------
#	Move Around
#-------------------------------------------------------------------------------
export DEVHOME=${HOME}/Development
export PROJHOME=${DEVHOME}/Projects
export ACTIVEPROJHOME=${PROJHOME}/Active
export CPEHOME=${ACTIVEPROJHOME}/CPE
export SGIPHOME=${CPEHOME}/SGIP
export AMSTARHOME=${ACTIVEPROJHOME}/AMSTAR
export AVSTILHOME=${ACTIVEPROJHOME}/AvSTIL

alias goCPE='cd "${CPEHOME}" ; youarehere'
alias goAMSTAR='cd "${AMSTARHOME}" ; youarehere'
alias goSGIP='cd "${SGIPHOME}" ; youarehere'
alias goAvSTIL='cd "${AVSTILHOME}" ; youarehere'

################################################################################
#	Edit/Apply mods to functions/aliases etc.
################################################################################
#	.bashrc
alias rebash='source ~/.bashrc'
alias edbash='sublime ~/.bashrc &'
#	Functions
alias edfunc='sublime ~/bin/scripts/main/functions.sh'
alias refunc='source   ~/bin/scripts/main/functions.sh'
#	Aliases	
alias edalias='sublime ~/bin/scripts/main/aliases.sh'
alias realias='source   ~/bin/scripts/main/aliases.sh'
#	Environment
alias edenviro='sublime ~/bin/scripts/main/environment.sh'
alias reenviro='source   ~/bin/scripts/main/environment.sh'

################################################################################
#	System Information
################################################################################
alias myversion='lsb_release -a'
alias numcpus='nproc'


################################################################################
#	Permissions
################################################################################
alias getfp='stat -c "%n %a %A %F" $1'

################################################################################
#	
################################################################################
alias showshm="watch 'od -x $1'"

alias mountOldDirve="sudo mount -o loop,rw ~/Elements/Linux/image.dd  /media/xfsimage/"


# Search for a <pattern> string inside all files in the current directory
# This is how I typically grep. 
# 	-R recurse into subdirectories, 
# 	-n show line numbers of matches, 
# 	-i ignore case, 
# 	-s suppress "doesn't exist" and "can't read" messages, 
# 	-I ignore binary files (technically, process them as having no matches, important for showing inverted results with -v)
# I have grep aliased to "grep --color=auto" as well, but that's a matter of formatting not function.
# .
#	grep -RnisI <pattern> *

################################################################################
#	Search
################################################################################
alias whereami='echo $HOSTNAME'
alias grep='grep -sI --color=auto'
alias howdoi='apropos'



################################################################################
#	GIT Related
################################################################################
alias glo='git log --oneline'
alias gba='git branch -a'
alias gco='git checkout'
alias gitstatus='git status'
alias gstat='git status'
alias gss='git status -s'
alias gitcommit='git commit --verbose'
alias gitpush='git push --verbose'
alias gitshowremote='git remote -v'
alias gsr='gitshowremote'
alias diff2ReposNoDotGit='diff --brief -r --exclude=".git"'
alias gr='git revert'


################################################################################
#	Backup
################################################################################
# alias backupHome='source ~/bin/scripts/rsbackup.sh -s /home/peddycoartte -d /proj/PEDDYCOART/CURRENT_HOME'
alias createArchive='~/bin/scripts/backup/createArchive.sh'
alias backupForTransfer='~/bin/scripts/backup/backupForTransfer.sh'


alias youarehere='printLocation $1'



################################################################################
#	Navigation
###################X############################################################
alias uvc='ssh -q -X RTSG@ihawk102'
alias uvr='ssh -q -X RTSG@ihawk105'
alias uvf='ssh -q -X RTSG@hawk'

alias uvcEP='ssh -q -Y ihawk102'
alias uvrEP='ssh -q -Y ihawk105'
alias uvfEP='export XAUTHORITY=~/.Xauthority; ssh -Y hawk'

alias goCompositor='export XAUTHORITY=~/.Xauthority; ssh -YX compositor'
alias goMyAvMcMachine='export XAUTHORITY=~/.Xauthority; ssh -YX ${MY_AVMC_MACHINE}'
alias goTeamCity6AsMe='export XAUTHORITY=~/.Xauthority; ssh -YX ss-teamcity6-lnx'
alias goTeamCity7AsMe='export XAUTHORITY=~/.Xauthority; ssh -YX ss-patton-lnx'
alias goTeamCity6='export XAUTHORITY=~/.Xauthority; ssh -YX teamcity@ss-teamcity6-lnx'
alias goTeamCity7='export XAUTHORITY=~/.Xauthority; ssh -YX teamcity@ss-patton-lnx'

alias goProjDoc='cd $HOME/Development/AEgisBitBucket/epeddycoart/ProjectDocumentation'

# alias goDevelopment='cd "${DEV_ROOT}"; youarehere'
# alias goSource='cd "${SOURCE_ROOT}"; youarehere'
# alias goProjects='cd "${PROJECTS_ROOT}"; youarehere'
# alias goAvSTIL='cd "${AVSTIL_PROJECTS_ROOT}"; youarehere'

alias goArchive='cd /archive; youarehere'
alias goBackups='cd "${BACKUP_ROOT}"; youarehere'


################################################################################
#	
################################################################################
alias lasudo='sudo !!'


################################################################################
#	Development	
################################################################################
# alias mtmake='~/bin/scripts/development/mtbuild.sh'
alias smartgit='smartgit.sh &'
alias fastDelete='$HOME/bin/scripts/utility/fastDelete.sh '
alias checkCMakeCache='egrep "BUILD_TYPE|BUILD_DOCS|BUILD_WITH_CUDA|FORCE_3RDPARTY|BUILD_TESTS|CMAKE_INSTALL_PREFIX:PATH=|OSG_DEBUG" CMakeCache.txt'
#alias checkCMakeCache='egrep "BUILD_TYPE|BUILD_DOCS|BUILD_WITH_CUDA|FORCE_3RDPARTY|BUILD_TESTS|CMAKE_INSTALL_PREFIX:PATH=|OSG_DEBUG" CMakeCache.txt'

################################################################################
#	Documents
################################################################################
alias readpdf='evince'



################################################################################
#	Network
################################################################################
alias wpihawk102='watch ping -c 1 ihawk102'
alias wpihawk105='watch ping -c 1 ihawk102'
alias wphawk='watch ping -c 1 hawk'

alias wi102='watch ping -c 1 ihawk102'
alias wi105='watch ping -c 1 ihawk102'
alias wh='watch ping -c 1 hawk'


################################################################################
#	Misc
################################################################################
alias rmd='rm -frv'		
alias srmd='sudo rm -frv'		

# alias rm='rm -i'
alias cp='cp -i'
alias cpb='copyWithProgressBar'
alias mv='mv -i -v'

alias mkdir='mkdir -p'	# -> Prevents accidentally clobbering files.

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
#alias du='du -kh'       # Makes a more readable output.
#alias df='df -kTh'
alias df='df -kT'
alias mountcol='mount |column -t'
alias mount='mount |column -t'

# This is GOLD for finding out what is taking so much space on your drives!
alias diskspace="du -S | sort -n -r |more"
alias sudiskspace="sudo du -S | sort -n -r |more"

# Show me the size (sorted) of only the folders in this directory
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"
alias sufolders="sudo find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"

#alias foldersH="find . -maxdepth 1 -type d -print | xargs du -sh | sort -rn"
#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls)
#-------------------------------------------------------------
alias la='ls -Al'          # show hidden files
alias lb='ls'
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lk='ls -lSr'         # sort by size, biggest last
alias ll='ls -l --group-directories-first'
alias lm='ls -al |more'    # pipe through 'more'
alias lr='ls -lR'          # recursive ls
#alias ls='ls -hF --color'  # add colors for filetype recognition
# alias ls='ls -F --color'  # add colors for filetype recognition
alias lt='ls -ltr'         # sort by date, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lx='ls -lXB'         # sort by extension
#alias tree='tree -Csu'     # nice alternative to 'recursive ls'
alias luser='ls -l | sort -k3,3'

alias shred='shred --force --remove --verbose --exact --zero'


alias getugid='getent group $1 | cut -d: -f3'

alias watch='watch -n 0.5'



# #alias compgen='compgen -v"
# ########################################
# # Task: show all the bash built-ins
# ########################################
# compgen -b
# ########################################
# # Task: show all the bash keywords
# ########################################
# compgen -k
# ########################################
# # Task: show all the bash functions
# ########################################
# compgen -A function
# Options for compgen command are the same as complete, except -p and -r. From compgen man page:

# compgen
#  compgen [option] [word]
#  Generate possible completion matches for word according to the options, which 
#  may be any option accepted by the complete builtin with the exception of -p 
#  and -r, and write the matches to the standard output

# For options [abcdefgjksuv]:

#     -a means Names of alias
#     -b means Names of shell builtins
#     -c means Names of all commands
#     -d means Names of directory
#     -e means Names of exported shell variables
#     -f means Names of file and functions
#     -g means Names of groups
#     -j means Names of job
#     -k means Names of Shell reserved words
#     -s means Names of service
#     -u means Names of userAlias names
#     -v means Names of shell variables

#alias todo='/home/peddycoartte/bin/todo.txt_cli-2.11.0/todo.sh'


