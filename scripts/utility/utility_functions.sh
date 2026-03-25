#!/bin/bash

#-------------------------------------------------------------------------------
# Bash Function To Rename Files Without Typing Full Name Twice
#-------------------------------------------------------------------------------
function epmv() 
{
  if [ "$#" -ne 1 ] || [ ! -e "$1" ]; then
    command mv "$@"
    return
  fi

  read -ei "$1" newfilename
  command mv -v -- "$1" "$newfilename"
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function checkFileExists()
{
	local __fileToCheck="${1}"
    local __resultvar="${2}"
    local myresult=1
	if [ ! -f "${__fileToCheck}" ]; then
  		myresult=0
  	fi

    eval $__resultvar="'$myresult'"
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function checkFileExistsAndExit()
{
  local __fileToCheck="${1}"
  if [ ! -f "${__fileToCheck}" ]; then
      printf "File Not Found!: %s\n" "${__fileToCheck}"
      exit 1;
  fi
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function checkDirExists()
{
	local __dirToCheck="${1}"
    local  __resultvar=$2
    local  myresult=1
	if [ ! -d "${__dirToCheck}" ]; then
  		myresult=0
  	fi

    eval $__resultvar="'$myresult'"

}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function checkDirExistsAndExit()
{
  local __dirToCheck="${1}"
  if [ ! -d "${__dirToCheck}" ]; then
      printf "Dir Not Found!: %s\n" "${__dirToCheck}"
      exit 1;
  fi
}


# #-------------------------------------------------------------------------------
# #                                                                               
# #-------------------------------------------------------------------------------
# cls()
# { 
# 	printf "\33[2J";
# }


################################################################################
if [ 1 -eq 0 ]; then

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function #pringSepLine()
{
	sepLength=$1
	if [[ -z "${sepLength// }" ]]; then
		sepLength=80
	fi   
	printf '%.0s-' $(seq 1 $sepLength)
	printf "\n"
}


# #pringSepLine 80
# printf "Loading Functions: %s\n" "$(date)"
# #pringSepLine 80

# trick for commenting out a block of code
#if [ 1 -eq 0 ]; then
#fi

###################################################
#	git related Functions
###################################################
# alias checkout='git checkout $1'
# alias branches='git branch -a'
# alias createbranchfromcurrent='git branch $1'
# alias createbanchfromother='git branch '
# alias showMyGitAliases=''


# #AEGIS_REPO_URL="ssh://git@gitlab.aegis.fay-ar.us:443/scenegen"
# #EP_REPO_URL="ssh://git@gitlab.aegis.fay-ar.us:443/epeddycoart"
# AEGIS_REPO_URL="git@github.aegistg.com:scenegen/"
# EP_REPO_URL="git@github.aegistg.com:Ed-Peddycoart/"
# EP_AMRDEC_REPO_URL="git@jsigci.ds.amrdec.army.mil:peddycoartte/"

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function mkdircd()
{ 
	mkdir "$1" && cd "$1" ; 
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function removeOffendingKey () 
{
	offendingKey=$1
	if [[ -z "${offendingKey// }" ]]; then
		printf "No OFFENDING KEY Specified\n"
	else
		printf -v cmd "sed -i '%dd' ~/.ssh/known_hosts" "${offendingKey}"
		# echo $cmd
		$cmd
	fi    
}



#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function bashVersion () 
{
	printf "##################################\n"
	printf "# BASH VERSION: $BASH_VERSION #\n"
	printf "##################################\n"
}
# function backupHome()
# {
# 	# rsync -avzr --progress --dry-run /home/peddycoartte /proj/PEDDYCOART/CURRENT_HOME/.
# 	# rsync -avzr --progress  /home/peddycoartte /proj/PEDDYCOART/CURRENT_HOME/.

# 	source ~/bin/scripts/rsbackup.sh -s /home/peddycoartte -d /proj/PEDDYCOART/CURRENT_HOME
# }



#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function printLocation() 
{
	localSepLength=80
	printf "=%.0s" $(seq 1 $localSepLength)
	printf "\n"
	printf "Here: %s\n" "$PWD"	
	printf "=%.0s" $(seq 1 $localSepLength)
	printf "\n"
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function goHere ()
{
	cd $1
	youarehere
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function fastrm ()
{
	sudo find $1 -mtime +0.5 -delete
#	find $1 -mtime +0.5 -print0 | xargs -0 rm -rf
	if [[ $? -ne 0 ]];
	then
		echo "Error deleting $1"
	fi

}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function ethDrvInfo  ()
{
	printf "Driver Information\n"
	printf -v cmd "ethtool -i eth%d" "$1"
	echo $cmd
	eval $cmd
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function ethDrvStats  ()
{
	printf "Driver Statistics\n"
	printf -v cmd "ethtool -s eth%d" "$1"
	echo $cmd
	eval $cmd
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function traceNIC ()
{
	printf "Tracing NIC\n"
	printf -v cmd "ethtool -p eth%d %d" "$1" "$2"
	echo $cmd
	eval $cmd
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function showPath () 
{
	printf ${PATH//:/\\n}
}


#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function dec2hex () 
{ 
	number=$1
	printf "%d = 0x%X\n"  "$number" "$number"; 
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function hex2dec () 
{ 
	number=$1
	printf '%s = %d\n' "$number" "$number"
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function folderSizes () 
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	duArgs=$2
	if [[ -z "${duArgs// }" ]]; then
		duArgs="-sh"
	fi    

	numberToList=$3
	if [[ -z "${numberToList// }" ]]; then
		numberToList="10"
	fi    


	#pringSepLine 80
	printf "Folder Size for %s\n" "$searchPath"
	#pringSepLine 80


# #	find $searchPath -name $searchObject -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberToList"

# #	find $searchPath -maxdepth 1 -type d -print | xargs du $duArgs| sort -rn
# 	printf -v cmd "find %s -maxdepth 1 -type d -print | xargs du %s | sort -rn" "$searchPath" "$duArgs"
# #	printf -v cmd "find %s -maxdepth 1 -type d -print | xargs du -sh | sort -rn " "$searchPath"
# 	printf "Executing: %s\n" "$cmd"
# 	printf "\n"
# 	eval $cmd


	printf -v cmd "find %s -maxdepth 1 -type d |xargs du -sh * | sort -rh " "$searchPath"
	printf "CMD: %s\n" "${cmd}"
	eval "${cmd}"

}

function folderSizesReversed () 
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	duArgs=$2
	if [[ -z "${duArgs// }" ]]; then
		duArgs="-sh"
	fi    

	numberToList=$3
	if [[ -z "${numberToList// }" ]]; then
		numberToList="10"
	fi    


	#pringSepLine 80
	printf "Folder Size for %s\n" "$searchPath"
	#pringSepLine 80


# #	find $searchPath -name $searchObject -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberToList"

# #	find $searchPath -maxdepth 1 -type d -print | xargs du $duArgs| sort -rn
# 	printf -v cmd "find %s -maxdepth 1 -type d -print | xargs du %s | sort -rn" "$searchPath" "$duArgs"
# #	printf -v cmd "find %s -maxdepth 1 -type d -print | xargs du -sh | sort -rn " "$searchPath"
# 	printf "Executing: %s\n" "$cmd"
# 	printf "\n"
# 	eval $cmd


	printf -v cmd "find %s -maxdepth 1 -type d |xargs du -sh * | sort -h " "$searchPath"
	printf "CMD: %s\n" "${cmd}"
	eval "${cmd}"

}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function sudoFolderSizes () 
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	duArgs=$2
	if [[ -z "${duArgs// }" ]]; then
		duArgs="-sh"
	fi    

	numberToList=$3
	if [[ -z "${numberToList// }" ]]; then
		numberToList="10"
	fi    


	#pringSepLine 80
	printf "Folder Size for %s\n" "$searchPath"
	#pringSepLine 80


	printf -v cmd "sudo find %s -maxdepth 1 -type d |sudo xargs du -sh * |sudo sort -rh " "$searchPath"
	printf "CMD: %s\n" "${cmd}"
	eval "${cmd}"

}

#-------------------------------------------------------------
# extract archives
#-------------------------------------------------------------
function extract()      # Handy Extract Program.
{
	FileToExtract=$1

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "Extracting %s\n" "$FileToExtract"
	printf "%s\n" "------------------------------------------------------------"

	# .tar.bz2 	.tb2, .tbz, .tbz2
	# .tar.gz 	.tgz
	# .tar.lz 	
	# .tar.lzma 	.tlz
	# .tar.xz 	.txz
	# .tar.Z
	# Compression options:
	# 	-a, --auto-compress        use archive suffix to determine the compression program
	# 	-I, --use-compress-program=PROG
	# 	                           filter through PROG (must accept -d)
	# 	-j, --bzip2                filter the archive through bzip2
	# 	-J, --xz                   filter the archive through xz
	# 	    --lzip                 filter the archive through lzip
	# 	    --lzma                 filter the archive through lzma
	# 	    --lzop
	# 	    --no-auto-compress     do not use archive suffix to determine the compression program
	# 	-z, --gzip, --gunzip, --ungzip   filter the archive through gzip
	# 	-Z, --compress, --uncompress   filter the archive through compress

	if [ -f $FileToExtract ] ; then
		case $FileToExtract in
			*.7z)        7za x $1        ;;
			*.bz2)       bunzip2 $1      ;;
			*.gz)        gunzip $1       ;;
			*.rar)       unrar x $1      ;;
			*.tar)       tar xvf $1      ;;
			*.tar.bz2)   tar xvjf $1     ;;
			*.tar.gz)    tar xvzf $1     ;;
			*.tbz2)      tar xvjf $1     ;;
			*.tgz)       tar xvzf $1     ;;
			*.zip)       unzip $1        ;;
			*.xz)        tar xvJf $1     ;;
			*.Z)         uncompress $1   ;;
			*)           echo "'$FileToExtract' cannot be extracted via >extract<" ;;
		esac
	else
		echo "'$FileToExtract' is not a valid file"
	fi

	printf "\n\n"

}



#-------------------------------------------------------------
# 	change user/group ownership of $1 to current user/group
#-------------------------------------------------------------
function allMineDir()
{
	printf "\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	username=$(id -u -n)
  	groupname=$(id -g -n)
	what=$1

	cmd="sudo chown "
	cmd+="-R "
	cmd+=$username":"$groupname" "
	cmd+=$what
	
	printf -v cmd "sudo find %s -not -user %s -execdir chown %s:%s {} \\+" "${what}" "${username}" "${username}" "${groupname}"

	echo $cmd
	printf "Changing ownership of %s to %s:%s\n" "$what" "$username" "$groupname"
	printf "Executing %s\n" "$cmd"
	printf "Results: \n"
  	eval $cmd
  	# sudo chmod o-rwx $what


  	printf "\n"
}

#-------------------------------------------------------------
# 	change user/group ownership of $1 to current user/group
#-------------------------------------------------------------
function allmine()
{
	printf "\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	username=$(id -u -n)
  	groupname=$(id -g -n)
	what=$1

	cmd="sudo chown "
	cmd+="-R "
	cmd+=$username":"$groupname" "
	cmd+=$what
	
	echo $cmd
	printf "Changing ownership of %s to %s:%s\n" "$what" "$username" "$groupname"
	printf "Executing %s\n" "$cmd"
	printf "Results: \n"
  	$cmd
  	sudo chmod o-rwx $what

  	printf "\n"
}

#-------------------------------------------------------------
# 	change user/group ownership of $1 to current user/group
#-------------------------------------------------------------
function vallmine()
{
	printf "\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	username=$(id -u -n)
  	groupname=$(id -g -n)
	what=$1

	cmd="sudo chown "
	cmd+="-vR "
	cmd+=$username":"$groupname" "
	cmd+=$what
	
	echo $cmd
	printf "Changing ownership of %s to %s:%s\n" "$what" "$username" "$groupname"
	printf "Executing %s\n" "$cmd"
	printf "Results: \n"
  	$cmd
  	sudo chmod o-rwx $what

  	printf "\n"
}
#-------------------------------------------------------------
# 	change group ownership of $1 to current user/group
#-------------------------------------------------------------
function mygroup()
{
  	printf "\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	username=$(id -u -n)
  	groupname=$(id -g -n)
	what=$1

  	cmd="sudo chgrp "
	cmd+="-vR "
  	cmd+=$groupname" "
  	cmd+=$what

	echo $cmd

	printf "Changing group ownership of %s to :%s\n" "$what" "$groupname"
	printf "Executing %s\n" "$cmd"
	printf "Results: \n"
  	$cmd
  	#sudo chmod o-rwx $what

  	printf "\n"

}


#-------------------------------------------------------------------------------
# User Functions
#-------------------------------------------------------------------------------

function path() 
{
	# printf "\n\n"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "Function: %s\n\n" "$FUNCNAME"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "\n\n"
	printf "########################################################\n"
	printf "# PATH                                                 #\n"
	printf "########################################################\n"
	echo -e ${PATH//:/\\n}
}

function libpath() 
{
	# printf "\n\n"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "Function: %s\n\n" "$FUNCNAME"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "\n\n"
	printf "########################################################\n"
	printf "# LD_LIBRARY_PATH                                      #\n"
	printf "########################################################\n"
	echo -e ${LD_LIBRARY_PATH//:/\\n}
}

function filepath() 
{
	# printf "\n\n"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "Function: %s\n\n" "$FUNCNAME"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "\n\n"
	printf "########################################################\n"
	printf "# OSG_FILE_PATH                                        #\n"
	printf "########################################################\n"
	echo -e ${OSG_FILE_PATH//:/\\n}
}

#-------------------------------------------------------------
# parse PATH, LD_LIBRARY_PATH and OSG_FILE_PATH and print
#-------------------------------------------------------------
function paths()
{

	printf "########################################################\n"
	printf "# PATH                                                 #\n"
	printf "########################################################\n"
	path

	printf "########################################################\n"
	printf "# LD_LIBRARY_PATH                                      #\n"
	printf "########################################################\n"
	libpath

	printf "########################################################\n"
	printf "# OSG_FILE_PATH                                        #\n"
	printf "########################################################\n"
	filepath

}

#-------------------------------------------------------------
# dump RTSG env vars
#-------------------------------------------------------------
function rtsgenv() 
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"
	printf "########################################################\n"
	printf "# RTSG Environment Variables                           #\n"
	printf "########################################################\n"
	printf "# OSG_NOTIFY_LEVEL:           %s\n" "$OSG_NOTIFY_LEVEL"
	printf "#                               \n"
	printf "# BOOST_Dir:                  %s\n" "$BOOST_Dir"
	printf "# BOOST_ROOT:                 %s\n" "$BOOST_ROOT"
	printf "# BOOSTROOT:                  %s\n" "$BOOSTROOT"
	printf "#                               \n"
	printf "# SIGFW:                      %s\n" "$SIGFW"
	printf "# THREATCONFIGS:              %s\n" "$THREATCONFIGS"
	printf "# \n"
	printf "# CONTINUUM:                  %s\n" "$CONTINUUM"
	printf "#                               \n"
	printf "# IGStudio:                   %s\n" "$IGStudio"
	printf "#    JSIG_DATA:               %s\n" "$JSIG_DATA"
	printf "#    OSG_DIR:                 %s\n" "$OSG_DIR"
	printf "#    OSGDIR:                  %s\n" "$OSGDIR"
	printf "#    OSG_ROOT:                %s\n" "$OSG_ROOT"
	printf "#    OSG_EARTHANNOTATION_LIB: %s\n" "$OSG_EARTHANNOTATION_LIB"
	printf "#    OSG_EARTHFEATURES_LIB:   %s\n" "$OSG_EARTHFEATURES_LIB"
	printf "#    OSG_EARTHSYMBOLOGY_LIB:  %s\n" "$OSG_EARTHSYMBOLOGY_LIB"
	printf "#    OSG_EARTHUTIL_LIB:       %s\n" "$OSG_EARTHUTIL_LIB"
	printf "#    OSG_EARTH_LIB:           %s\n" "$OSG_EARTH_LIB"
	printf "#    SILVERLINING_PATH:       %s\n" "$SILVERLINING_PATH"
	printf "#    TRITON_PATH :            %s\n" "$TRITON_PATH"
	printf "#                               \n"
	printf "# AMIE:                       %s\n" "$AMIE"
	printf "#                               \n"
	printf "# TESTBED_ROOT:               %s\n" "$TESTBED_ROOT"
	printf "########################################################\n"
  
	if [ -n "$1" ]; then
		paths
	fi
}

#-------------------------------------------------------------
# dump RTSG env vars and also show realpaths of symlinks 
#-------------------------------------------------------------
function rtsgEnvRealPath() 
{




	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	printf "########################################################\n"
	printf "# RTSG Environment Variables                           #\n"
	printf "########################################################\n"
	printf "#                               \n"
	printf "# OSG_NOTIFY_LEVEL:           %s\n" "$OSG_NOTIFY_LEVEL"
	printf "#                               \n"
	printf "# BOOST_Dir:                  %s\n" "$BOOST_Dir"
	if [ -n "$BOOST_Dir" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $BOOST_Dir)
	fi
	printf "# BOOST_ROOT:                 %s\n" "$BOOST_ROOT"
	if [ -n "$BOOST_ROOT" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $BOOST_ROOT)
	fi
	printf "# BOOSTROOT:                  %s\n" "$BOOSTROOT"
	if [ -n "$BOOSTROOT" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $BOOSTROOT)
	fi
	printf "#                               \n"
	printf "# SIGFW:                      %s\n" "$SIGFW"
	if [ -n "$SIGFW" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $SIGFW)
	fi 
	printf "# THREATCONFIGS:              %s\n" "$THREATCONFIGS"
	if [ -n "$THREATCONFIGS" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $THREATCONFIGS)
	fi
	printf "# \n"
	printf "# CONTINUUM:                  %s\n" "$CONTINUUM"
	if [ -n "$CONTINUUM" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $CONTINUUM)
	fi
	printf "#                               \n"
	printf "# CUDA_PATH                   %s\n" "$CUDA_PATH"
	printf "# CUDA_ROOT                   %s\n" "$CUDA_ROOT"
	printf "# CUDA_BIN_DIR                %s\n" "$CUDA_BIN_DIR"
	printf "# CUDA_LIB_DIR                %s\n" "$CUDA_LIB_DIR"

	printf "#                               \n"
	printf "# IGStudio:                   %s\n" "$IGStudio"
	if [ -n "$IGStudio" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $IGStudio)
	fi
	printf "#                               \n"
	printf "# IGStudio5:                   %s\n" "$IGStudio5"
	if [ -n "$IGStudio5" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $IGStudio5)
	fi
	printf "#                               \n"
	printf "# IGSTUDIO:                   %s\n" "$IGSTUDIO"
	if [ -n "$IGSTUDIO" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $IGSTUDIO)
	fi
	printf "#                               \n"
	printf "# IGSTUDIO_DIR:               %s\n" "$IGSTUDIO_DIR"
	if [ -n "$IGSTUDIO_DIR" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $IGSTUDIO_DIR)
	fi
	printf "#    JSIG_DATA:               %s\n" "$JSIG_DATA"
	printf "#    OSG_DIR:                 %s\n" "$OSG_DIR"
	printf "#    OSGDIR:                  %s\n" "$OSGDIR"
	printf "#    OSG_ROOT:                %s\n" "$OSG_ROOT"
	printf "#    OSGEARTH_DIR             %s\n" "$OSGEARTH_DIR"
	printf "#    OSGEARTH_LIBRARY_PATH:   %s\n" "$OSGEARTH_LIBRARY_PATH"
	printf "#    OSG_EARTHANNOTATION_LIB: %s\n" "$OSG_EARTHANNOTATION_LIB"
	printf "#    OSG_EARTHFEATURES_LIB:   %s\n" "$OSG_EARTHFEATURES_LIB"
	printf "#    OSG_EARTHSYMBOLOGY_LIB:  %s\n" "$OSG_EARTHSYMBOLOGY_LIB"
	printf "#    OSG_EARTHUTIL_LIB:       %s\n" "$OSG_EARTHUTIL_LIB"
	printf "#    OSG_EARTH_LIB:           %s\n" "$OSG_EARTH_LIB"
	printf "#    SILVERLINING_PATH:       %s\n" "$SILVERLINING_PATH"
	printf "#    TRITON_PATH :            %s\n" "$TRITON_PATH"
	printf "#                               \n"
	printf "# AMIE:                       %s\n" "$AMIE"
	if [ -n "$AMIE" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $AMIE)
	fi
	printf "#                               \n"
	printf "# TESTBED_ROOT:               %s\n" "$TESTBED_ROOT"
	if [ -n "$TESTBED_ROOT" ]; then
		printf "#    Acutal Path:             %s\n" $(readlink -e $TESTBED_ROOT)
	fi
	printf "########################################################\n"

	if [ -n "$1" ]; then
		paths
	fi
}

#-------------------------------------------------------------
# Initialize 3RDParty
#-------------------------------------------------------------
function clear3RDPartyEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset BOOST_1_44_0
	unset BOOST_1_58_0
	unset BOOST_1_59_0
	unset BOOST_Dir
	unset BOOST_Dirs
	unset BOOST_ROOT
	unset BOOSTROOT

	unset CUDA_BIN_DIR
	unset CUDA_LIB_DIR
	unset CUDA_PATH
	unset CUDA_ROOT

}
#-------------------------------------------------------------
# Initialize 3RDParty
#-------------------------------------------------------------
function Initialize3RDParty()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	export BOOST_1_44_0=$SOFTWARE_ROOT/boost/boost_1_44_0
	export BOOST_1_58_0=$SOFTWARE_ROOT/boost/boost_1_58_0
	export BOOST_1_59_0=$SOFTWARE_ROOT/boost/boost_1_59_0

	export BOOST_Dir=$BOOST_1_44_0
	export BOOST_Dirs=$BOOST_1_44_0
	export BOOST_ROOT=$BOOST_1_44_0
	export BOOSTROOT=$BOOST_1_44_0
}

#-------------------------------------------------------------
# Initialize Continuum Environment Variables
#-------------------------------------------------------------
function clearContinuumEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset CONTINUUM
	unset CONTINUUM_BIN
	unset CONTINUUM_INC
	unset CONTINUUM_LIB

	# export LD_LIBRARY_PATH=$CONTINUUM_LIB:$LD_LIBRARY_PATH

	# if ! echo ${PATH} | /bin/grep -q $CONTINUUM_BIN ; then
	#   export PATH=$CONTINUUM_BIN:${PATH}
	# fi
}

#-------------------------------------------------------------
# Initialize Continuum Environment Variables
#-------------------------------------------------------------
function InitializeContinuumEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset CONTINUUM
	export CONTINUUM=$PWD/Continuum
	export CONTINUUM=$PWC/JSIG-build
	export CONTINUUM_BIN=$CONTINUUM/bin
	export CONTINUUM_INC=$CONTINUUM/include
	export CONTINUUM_LIB=$CONTINUUM/lib

	export LD_LIBRARY_PATH=$CONTINUUM_LIB:$LD_LIBRARY_PATH

	if ! echo ${PATH} | /bin/grep -q $CONTINUUM_BIN ; then
	  export PATH=$CONTINUUM_BIN:${PATH}
	fi
}

#-------------------------------------------------------------
# Initialize IGStudio Environment Variables
#-------------------------------------------------------------
function clearIGStudioEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset IGStudio
	unset IGSTUDIO
	unset IGSTUDIO_DIR
	unset JSIG_HOME
	unset JSIG_INSTALL_DIR
	unset JSIG5_BUILD_DIR
	unset JSIG_DATA
	unset SILVERLINING_PATH
	unset OPENALDIR
	unset OSGEARTH_LIBRARY_PATH
	unset OSG_EARTHANNOTATION_LIB
	unset OSG_EARTHFEATURES_LIB
	unset OSG_EARTHSYMBOLOGY_LIB
	unset OSG_EARTHUTIL_LIB
	unset OSG_EARTH_LIB
	unset OSGEARTH_LIBRARY_PATH
	unset OSGEARTH_DIR
	unset OSGEARTH_ROOT
	unset OSGEARTH_LIBRARY_PATH
	unset TRITON_PATH

	# if ! echo ${PATH} | /bin/grep -q $IGStudio/bin ; then
	#   export PATH=$IGStudio/bin:${PATH}
	# fi

}

#-------------------------------------------------------------
# Initialize IGStudio Environment Variables
#-------------------------------------------------------------
function InitializeIGStudioEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset IGStudio
	unset JSIG_DATA

	export IGStudio=$PWD/JSIG-build
	export JSIG_DATA=$IGStudio/JSIG_Data
	export LD_LIBRARY_PATH=$IGStudio/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$IGStudio/3rdParty/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$IGStudio/lib/armControllers/Qt:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$IGStudio/lib/armTypes/Emplacements:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$IGStudio/lib/armTypes/Osg:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$IGStudio/3rdParty/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$IGStudio/3rdParty/osg/lib/osgPlugins-3.4.0:$LD_LIBRARY_PATH
	export OSG_FILE_PATH=$IGStudio/bin/shaders:$OSG_FILE_PATH

	export OSG_FILE_PATH=$IGStudio/JSIG_Data:$OSG_FILE_PATH
	export OSG_FILE_PATH=$IGStudio/JSIG_Data/Models:$OSG_FILE_PATH
	export OSG_FILE_PATH=$IGStudio/JSIG_Data/Shaders:$OSG_FILE_PATH
	export OSG_FILE_PATH=$IGStudio/JSIG_Data/Textures:$OSG_FILE_PATH


	export SILVERLINING_PATH=$IGStudio/3rdParty/SilverLining
	export OPENALDIR=$IGStudio/3rdParty

	export OSGEARTH_LIBRARY_PATH==$IGStudio/3rdParty/osg
	export OSG_EARTHANNOTATION_LIB=$IGStudio/3rdParty/osg
	export OSG_EARTHFEATURES_LIB=$IGStudio/3rdParty/osg
	export OSG_EARTHSYMBOLOGY_LIB=$IGStudio/3rdParty/osg
	export OSG_EARTHUTIL_LIB=$IGStudio/3rdParty/osg
	export OSG_EARTH_LIB=$IGStudio/3rdParty/osg
	export OSGEARTH_LIBRARY_PATH=$IGStudio/3rdParty/osg/lib

	export OSGEARTH_DIR=$IGStudio/3rdParty/osg
	export OSGEARTH_ROOT=$IGStudio/3rdParty/osg
	export OSGEARTH_LIBRARY_PATH=$IGStudio/3rdParty/osg/lib

	export TRITON_PATH=$IGStudio/3rdParty/Triton

	if ! echo ${PATH} | /bin/grep -q $IGStudio/bin ; then
	  export PATH=$IGStudio/bin:${PATH}
	fi

}

#-------------------------------------------------------------
# Initialize OpenSeneGraph Environment Variables
#-------------------------------------------------------------
function clearOpenSeneGraphEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset OSGDIR
	unset OSG_DIR
	unset OSG_ROOT

	# if ! echo ${PATH} | /bin/grep -q $OSG_ROOT/bin ; then
	#   export PATH=$OSG_ROOT/bin:${PATH}
	# fi

	# export LD_LIBRARY_PATH=$OSG_ROOT/lib:$OSG_ROOT/lib/osgPlugins-3.4.0:$LD_LIBRARY_PATH
}


#-------------------------------------------------------------
# Initialize OpenSeneGraph Environment Variables
#-------------------------------------------------------------
function InitializeOpenSeneGraphEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset OSGDIR
	unset OSG_DIR
	unset OSG_ROOT

	export OSG_DIR=$IGStudio/3rdParty/osg
	export OSGDIR=$IGStudio/3rdParty/osg
	export OSG_ROOT=$IGStudio/3rdParty/osg
	export OSG_FILE_PATH=$PWD/OpenSceneGraph-Data:$OSG_FILE_PATH

	if ! echo ${PATH} | /bin/grep -q $OSG_ROOT/bin ; then
	  export PATH=$OSG_ROOT/bin:${PATH}
	fi

	export LD_LIBRARY_PATH=$OSG_ROOT/lib:$OSG_ROOT/lib/osgPlugins-3.4.0:$LD_LIBRARY_PATH
}

#-------------------------------------------------------------
# Initialize RTSG Environment Variables
#-------------------------------------------------------------
function clearRTSGEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset APNTSRC_DATA
	unset AMIE
	unset TESTBED_ROOT
	unset SIGFW
	unset THREATCONFIGS
	unset RTSG_ROOT
}

#-------------------------------------------------------------
# Initialize RTSG Environment Variables
#-------------------------------------------------------------
function InitializeRTSGEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	unset APNTSRC_DATA
	unset AMIE
	unset TESTBED_ROOT
	unset SIGFW
	unset THREATCONFIGS
	unset RTSG_ROOT

	export RTSG_ROOT=/home/peddycoartte/Development/Projects/RTSG/code/src
	export AMIE=$RTSG_ROOT/AMIE/uPluginLib
	export APNTSRC_DATA=$RTSG_ROOT/APNTSRC
	export SIGFW=$RTSG_ROOT/SigFWAPI
	export SIGFW_MODELS=$RTSG_ROOT/SignaturesFramework/SignatureModels/
	export THREATCONFIGS=$RTSG_ROOT/ThreatConfigurations
	export TESTBED_ROOT=/home/rtsgshare/RTSG/testbeds
}

#-------------------------------------------------------------------------------
# initialize dev env
#-------------------------------------------------------------------------------
function clearDevEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	clear3RDPartyEnv
	clearRTSGEnv
	clearContinuumEnv
	clearIGStudioEnv
	clearOpenSeneGraphEnv
}

#-------------------------------------------------------------------------------
# initialize dev env
#-------------------------------------------------------------------------------
function InitializeDevEnv()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	InitializeRTSGEnv
	InitializeContinuumEnv
	InitializeIGStudioEnv
	InitializeOpenSeneGraphEnv
}

#-------------------------------------------------------------
# create date/time stamp with option tag
#-------------------------------------------------------------
function genDateTime()
{
	currentTime=$(date "+%Y_%m_%d_T%H_%M_%S")
	echo  $currentTime
}

#-------------------------------------------------------------
# create date/time stamp with option tag
#-------------------------------------------------------------
function genDateTag()
{
	currentDate=$(date "+%Y_%m_%d")
	echo  $currentDate
}



#-------------------------------------------------------------
# create date/time stamp with option tag
#-------------------------------------------------------------
function createDateTimeTag()
{
	# printf "\n\n"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "Function: %s\n\n" "$FUNCNAME"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "\n\n"

	currentTime=$(date "+%Y_%m_%d_T%H_%M_%S")

	tag=$1

	if [[ -z "${tag// }" ]]; then
		dateTimeTag=$currentTime
	else
		dateTimeTag="$currentTime"."$tag"
	fi    

	printf "Time Stamp: %s \n" $dateTimeTag
}


#-------------------------------------------------------------
# create directory with date/tag stamps
#-------------------------------------------------------------
function testTar()
{

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	FileToExtract="$1"

	printf "%s\n" "------------------------------------------------------------"
	printf "Attempting to test: %s\n" "${tarFile}"


	if [ -f $FileToExtract ] ; then
		case $FileToExtract in
			*.tar)       tar xvf $FileToExtract -O > /dev/null	;;
			*.tar.bz2)   tar xvjf $FileToExtract -O > /dev/null	;;
			*.tar.gz)    tar xvzf $FileToExtract -O > /dev/null	;;
			*.tbz2)      tar xvjf $FileToExtract -O > /dev/null	;;
			*.tgz)       tar xvzf $FileToExtract -O > /dev/null	;;
			*)           echo "'$FileToExtract' cannot be extracted" ;;
		esac
	else
		echo "'$FileToExtract' is not a valid file"
	fi
	printf "Testing of %s " "$tarFile"
	if [ $? -eq 0 ];
	then
		printf " succeeded\n"
	else
		printf " failed\n"
	fi

	printf "%s\n" "------------------------------------------------------------"
}


#-------------------------------------------------------------
# create tagged tar file with md5sum 
#-------------------------------------------------------------
function createTaggedTimeStampedTarMD5()
{

	__dateTimeTag=$(date "+%Y_%m_%d_T%H_%M_%S")

	__targetDir="${1}"
	if [[ -z "${__targetDir// }" ]]; then
		printf "ERROR: Target Dir Must Be Specified\n"
		exit 
	fi   

	__tag="${2}"
	__tarFile="$__targetDir"."$__dateTimeTag"
	if [[ -z "${__tag// }" ]]; then
		__tarFile="${__targetDir}"."${__dateTimeTag}".tar
	else
		__tarFile="$__targetDir"."${__dateTimeTag}"."${__tag}".tar
	fi    


	__md5sumInfoFile="${__tarFile}"."md5suminfo"

	printf "Time Stamp:  %s \n" "${__dateTimeTag}"
	printf "Target Dir:  %s \n" "${__targetDir}"
	printf "Tar File:    %s \n" "${__tarFile}"
	printf "MD5SUM File: %s \n" "${__md5sumInfoFile}"


	printf "%s\n" "------------------------------------------------------------"
	printf "Attempting to create: %s\n" "${__tarFile}"

	printf -v cmd "tar cvzf %s %s" "${__tarFile}" "${__targetDir}"
	printf "Executing %s\n" "$cmd"
	$cmd

	tar -xvf "${__tarFile}" -O > /dev/null

	printf "%s\n" "------------------------------------------------------------"
	printf "Creation of %s " "${__tarFile}"
	if [ $? -eq 0 ];
	then
		printf " succeeded\n"
	else
		printf " failed\n"
	fi
	printf "%s\n" "------------------------------------------------------------"
	printf "compute MD5\n"
	md5sum "${__tarFile}" >> "${__md5sumInfoFile}"
	printf "%s\n" "------------------------------------------------------------"
	printf "Check MD5\n"
	md5sum -c "${__md5sumInfoFile}"
	printf "%s\n" "------------------------------------------------------------"

}

#-------------------------------------------------------------
# create directory with date/tag stamps
#-------------------------------------------------------------
function createTaggedTimeStampedTar()
{

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	createDateTimeTag

	#	DIR to TAR
	targetDir=$1 

	#	Optional TAG
	tag=$2

	tarFile="$targetDir"."$dateTimeTag"

	if [[ -z "${tag// }" ]]; then
		tarFile="$targetDir"."$dateTimeTag".tar
	else
		tarFile="$targetDir"."$dateTimeTag"."$tag".tar
	fi    

	printf "%s\n" "------------------------------------------------------------"
	printf "Attempting to create: %s\n" "${tarFile}"

	cmd="tar cvzf $tarFile $targetDir"
	printf "Executing %s\n" "$cmd"
	$cmd

	tar -xvf $tarFile -O > /dev/null

	printf "Creation of %s " "$tarFile"
	if [ $? -eq 0 ];
	then
		printf " succeeded\n"
	else
		printf " failed\n"
	fi

	# if [[ -f $tarFile ]]; then
	# 	printf " succeeded\n"
	# else
	# 	printf " failed\n"
	# fi


	printf "%s\n" "------------------------------------------------------------"
}


#-------------------------------------------------------------
# create directory with date/tag stamps
#-------------------------------------------------------------
function createTaggedTimeStampedSplitTarGZ()
{

# 	tar cvzf - TTEC/ | split --bytes=512MB - TTEC.backup.tar.gz.

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	createDateTimeTag

	#	DIR to TAR
	targetDir=$1 

	splitSize=$2

	#	Optional TAG
	tag=$3

	tarFile="$targetDir"."$dateTimeTag"

	if [[ -z "${tag// }" ]]; then
		tarFile="$targetDir"."$dateTimeTag".tar.gz"."
	else
		tarFile="$targetDir"."$dateTimeTag"."$tag".tar.gz"."
	fi    

	printf "%s\n" "------------------------------------------------------------"
	printf "Attempting to create: %s\n" "${tarFile}"

	printf -v cmd "tar cvzf - %s | split --bytes=%sMB - %s" "${targetDir}" "${splitSize}" "${tarFile}"
	printf "Executing %s\n" "$cmd"
	$cmd

	# tar -xvzf $tarFile -O > /dev/null

	# printf "Creation of %s " "$tarFile"
	# if [ $? -eq 0 ];
	# then
	# 	printf " succeeded\n"
	# else
	# 	printf " failed\n"
	# fi

	# if [[ -f $tarFile ]]; then
	# 	printf " succeeded\n"
	# else
	# 	printf " failed\n"
	# fi


	printf "%s\n" "------------------------------------------------------------"
}

#-------------------------------------------------------------
# create directory with date/tag stamps
#-------------------------------------------------------------
function createTaggedTimeStampedTarGZ()
{

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	createDateTimeTag

	#	DIR to TAR
	targetDir=$1 

	#	Optional TAG
	tag=$2

	tarFile="$targetDir"."$dateTimeTag"

	if [[ -z "${tag// }" ]]; then
		tarFile="$targetDir"."$dateTimeTag".tar.gz
	else
		tarFile="$targetDir"."$dateTimeTag"."$tag".tar.gz
	fi    

	printf "%s\n" "------------------------------------------------------------"
	printf "Attempting to create: %s\n" "${tarFile}"

	cmd="tar cvzf $tarFile $targetDir"
	printf "Executing %s\n" "$cmd"
	$cmd

	tar -xvzf $tarFile -O > /dev/null

	printf "Creation of %s " "$tarFile"
	if [ $? -eq 0 ];
	then
		printf " succeeded\n"
	else
		printf " failed\n"
	fi

	# if [[ -f $tarFile ]]; then
	# 	printf " succeeded\n"
	# else
	# 	printf " failed\n"
	# fi


	printf "%s\n" "------------------------------------------------------------"
}

#-------------------------------------------------------------
# create directory with date/tag stamps
#-------------------------------------------------------------
function createTaggedTimeStampedTarXZ()
{

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	createDateTimeTag

	#	DIR to TAR
	targetDir=$1 

	#	Optional TAG
	tag=$2

	tarFile="$targetDir"."$dateTimeTag"

	if [[ -z "${tag// }" ]]; then
		tarFile="$targetDir"."$dateTimeTag".tar.xz
	else
		tarFile="$targetDir"."$dateTimeTag"."$tag".tar.xz
	fi    

	printf "%s\n" "------------------------------------------------------------"
	printf "Attempting to create: %s\n" "${tarFile}"

	cmd="tar cvJf $tarFile $targetDir"
	printf "Executing %s\n" "$cmd"
	$cmd

	tar -xvJf $tarFile -O > /dev/null

	printf "Creation of %s " "$tarFile"
	if [ $? -eq 0 ];
	then
		printf " succeeded\n"
	else
		printf " failed\n"
	fi

	# if [[ -f $tarFile ]]; then
	# 	printf " succeeded\n"
	# else
	# 	printf " failed\n"
	# fi


	printf "%s\n" "------------------------------------------------------------"
}

#-------------------------------------------------------------
# create directory with date/tag stamps
#-------------------------------------------------------------
function createTaggedTimeStampedDir()
{

	# printf "\n\n"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "Function: %s\n\n" "$FUNCNAME"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "\n\n"

	createDateTimeTag

	targetDir=$1 
	tag=$2
	newDir="$targetDir"."$dateTimeTag"

	if [[ -z "${tag// }" ]]; then
		newDir="$targetDir"."$dateTimeTag"
	else
		newDir="$targetDir"."$dateTimeTag"."$tag"
	fi    

	printf "%s\n" "------------------------------------------------------------"
	printf "Attempting to create: %s\n" "${newDir}"

	mkdir -p $newDir

	printf "Creation of %s " "$newDir"
	if [[ -d $newDir ]]; then
		printf " succeeded\n"
	else
		printf " failed\n"
	fi
	printf "%s\n" "------------------------------------------------------------"
}

#-------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------
function createProjectTreeOld()
{
	# http://www.tecmint.com/10-useful-linux-command-line-tricks-for-newbies/
	#
	# Build Directory Trees with one Command
	#
	# You probably know that you can create new directories by using the mkdir command. 
	# So if you want to create a new folder you will run something like this:
	#
	# # mkdir new_folder
	#
	# But what, if you want to create 5 subfolders within that folder? Running mkdir 
	# 5 times in a row is not a good solution. Instead you can use -p option like that:
	#
	# # mkdir -p new_folder/{folder_1,folder_2,folder_3,folder_4,folder_5}
	#
	# In the end you should have 5 folders located in new_folder:
	#
	# # ls new_folder/
	#
	# folder_1 folder_2 folder_3 folder_4 folder_5
	#


	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	verbose=$2

	projectName=$1
	projectNameRoot=$projectName
	projectNameArchive=$projectName"/archive"
	projectNameData=$projectName"/data"
	projectNameDocs=$projectName"/docs"
	projectNameDesign=$projectName"/design"
	projectNameCode=$projectName"/code"
	projectNameCodeBuild=$projectName"/code/build"
	projectNameCodeSrc=$projectName"/code/src"
	projectNameCodeTest=$projectName"/code/test"

	if [[ -n "${verbose// }" ]]; then
		echo
		echo "Creating the following directory structure..."
		echo
		echo "$projectNameRoot"
		echo "$projectNameArchive"
		echo "$projectNameCode"
		echo "   $projectNameCodeSrc"
		echo "   $projectNameCodeTest"
		echo "   $projectNameCodeBuild"
		echo "$projectNameData"
		echo "$projectNameDesign"
		echo "$projectNameDocs"
		echo
	fi    

	if [ -d "$projectNameRoot" ]; 
	then

		createDateTimeTag 
		backupDir="$projectNameRoot"."$dateTimeTag"

		if [[ -n "${verbose// }" ]]; then
			printf "filedatetime: %s\n" "${dateTimeTag}"
			printf "backupDir:    %s\n" "${backupDir}"
		fi

		printf "Project %s already exists. Moving to %s.\n\n" "projectNameRoot" "$backupDir"
		mv $projectNameRoot $backupDir
	fi

#	mkdir -p $projectNameRoot
	mkdir -p $projectNameArchive
#	mkdir -p $projectNameCode
	mkdir -p $projectNameCodeSrc
	mkdir -p $projectNameCodeTest
	mkdir -p $projectNameCodeBuild
	mkdir -p $projectNameData
	mkdir -p $projectNameDesign
	mkdir -p $projectNameDocs

	if [[ -n "${verbose// }" ]]; then
		tree -d $projectNameRoot
	fi
}

function gitCreateEPProject()
{

	printf "=%.0s" {1..100}
	printf "\n"
	printf "Function: %s NOT IMPLEMENTED\n" "$FUNCNAME"
	printf '=%.0s' {1..100}
	printf "\n"

# 	repoFolder=$1

# 	cd repoFolder
# 	echo $pwd

# 	git init
# 	git remote add origin ${EP_REPO_URL}/${repoFolder}.git
# git add .
# git commit
# git push -u origin master

# $  cd <cloned repo dir>
# $ git remote set-url origin ssh://git@gitlab.aegis.fay-ar.us:443/scenegen/{PROJECT_NAME}.git
# $ git remote -v

}

#-------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------
function gitEPProjectCodeOnly()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	projectName=$1
	printf "Getting code for %s\n" "$projectName"

    cmd="git clone -v ${EP_REPO_URL}/${projectName}.git"
	printf "\nexecuting %s\n" "$cmd"
	$cmd
}

#-------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------
function gitAEgisProjectCodeOnly()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	projectName=$1
	printf "Getting code for %s\n" "$projectName"

	cmd="git clone --verbose --progress ${AEGIS_REPO_URL}/${projectName}.git"
#	cmd="git clone -v ssh://git@gitlab.aegis.fay-ar.us:443/scenegen/${projectName}.git"
	printf "\nexecuting %s\n" "$cmd"
	$cmd
}

#-------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------
function gitProjectCodeTree()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	projectName=$1

	if [[ -z "${projectName// }" ]]; then
		printf "No Project Name Specified\n"
	fi    

	printf "getting code for %s\n" "$projectName"

	currentDir=$PWD

	createProjectTree $projectName

	targetDir=$projectName/code/src
	printf "\nchanging to %s\n" "$targetDir"
	cd $targetDir
	pwd

	gitProjectCodeOnly $projectName

	printf "\nchanging to %s\n" "$currentDir"
	cd $currentDir

}

#-------------------------------------------------------------------------------
#	move and go to dir
#-------------------------------------------------------------------------------
mvg ()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"
	printf "Moving $1 to $2\n"
  	if [ -d "$2" ]; then
		printf "Changing to $2\n"
    	mv $1 $2 ;cd $2
  	else
    	mv $1 $2
  	fi
}

#-------------------------------------------------------------------------------
#	copy and go to dir
#-------------------------------------------------------------------------------
cpg ()
{
	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"
	printf "Copying $1 to $2\n"

  	if [ -d "$2" ];then
		printf "Changing to $2\n"
    	cp $1 $2 ; cd $2
  	else
    	cp $1 $2
  	fi
}

#-------------------------------------------------------------------------------
#	search path $1 and sort by number of occurrences of file type
#-------------------------------------------------------------------------------
function countFilesByExt()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	printf "\n\n"
	printf "%s\n" "------------------------------"
	printf "Number Of Files By Extension\n"
	printf "$searchPath\n"
	printf "%s\n" "------------------------------"
	find "${searchPath}" -type f | sed -n 's/..*\.//p' | sort -f | uniq -ic
	printf "\n\n"

}

#-------------------------------------------------------------------------------
#	search path $1 and count files
#-------------------------------------------------------------------------------
function countFiles()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    
	
	#find /archive/epeddycoart/Backups/ihawk -printf \\n | wc -l

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
#	printf "%s contains %s files\n" "$searchPath" "$(ls -lR $searchPath |wc -l)"
	printf "%s contains %s files\n" "$searchPath" "$(find $searchPath -printf \\n|wc -l)"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"
}

#-------------------------------------------------------------------------------
#   
#	search path $1 and find folder $2 and copy to $3
#   
#-------------------------------------------------------------------------------
function findFilesAndCopyTo()
{
	#	This worked, now to genericize it....
	#
	#	find /z2/shared/tools/AMIE/ -iname '*linux*64*.*' -exec sh -c ' exec cp  /home/peddycoartte/devel/ARCHIVE/' sh {} +
	# 	find /z2/shared/tools/AMIE/ -iname '*linux*64*.*' -exec sh -c ' exec cp "$@" /home/peddycoartte/devel/ARCHIVE/' sh {} +
	# 	find /z2/shared/tools/AMIE/ -iname '*linux*64*.*' -exec sh -c ' exec cp /home/peddycoartte/devel/ARCHIVE/' sh {} +
	#
	#

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	searchPath=$1
	searchObject=$2
	destination=$3

	if [[ -d "$searchPath" ]]; then 
		printf "Searching:    %s \n" "$searchPath"
		printf "For Folder:   %s \n" "$searchObject"
	fi

	if [[ -d "$destination" ]]; then 
		printf "Will Copy To: %s \n" "$destination"
		echo 
		printf -v findCommand "find %s -iname '%s' -exec sh -c ' exec cp \""\$@\"" %s' sh {} +"	 "$searchPath" "$searchObject" "$destination"
		printf "Find Command: %s\n" "$findCommand"
#		findCommand="find $searchPath -iname '$searchObject' -exec sh -c ' exec cp \""\$@\"" $destination' sh {} +"
		echo $findCommand
		"$findCommand"
		# echo "continue"

	else
		printf "%s Does Not Exist...Aborting\n" "$destination"
	fi

}


#-------------------------------------------------------------------------------
#   
#	search path $1 and find folder $2 and copy to $3
#   
#-------------------------------------------------------------------------------
function findFolderAndCopyTo()
{
	#	This worked, now to genericize it....
	#
	#	find /z2/shared/tools/AMIE/ -iname '*linux*64*.*' -exec sh -c ' exec cp  /home/peddycoartte/devel/ARCHIVE/' sh {} +
	#
	#

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	searchPath=$1
	searchObject=$2
	destination=$3

	if [[ -d "$searchPath" ]]; then 
		printf "Searching:    %s \n" "$searchPath"
		printf "For Folder:   %s \n" "$searchObject"
	fi

	if [[ -d "$destination" ]]; then 
		printf "Will Copy To: %s \n" "$destination"
		find $searchPath -name $searchObject -type d -exec cp -vaR {} $destination \;
	else
		printf "%s Does Not Exist...Aborting\n" "$destination"
	fi

}

#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
function sudoFindLatestVersionOfFolderWildCard()
{
	searchPath=$1
	searchObject=$2
	numberSearchResults=$3

	if [[ -z "${searchPath// }" ]]; then
		printf "searchPath is empty\n"
	fi    

	if [[ -z "${searchObject// }" ]]; then
		printf "searchObject is empty\n"
	fi    

	if [[ -z "${searchPath// }" ]] || [[ -z "${searchObject// }" ]] || [[ -z "${numberSearchResults// }" ]]; then 
#		printf "\nUsage: %s searchPath searchObject numberSearchResults \n\n" "$FUNCNAME"
		printf "\nUsage: %s searchPath searchObject numberSearchResults \n\n" "$FUNCNAME"

	else
	
		if [[ -z "${numberSearchResults// }" ]]; then
			numberSearchResults="10"
		fi  

		#pringSepLine 80
		printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
		printf "Showing %s Results \n" "$searchResults"
		#pringSepLine 80

#		find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"
		sudo find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"
		#pringSepLine 80

	fi    
}


#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
function findLatestVersionOfFileWithWildCard()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	searchObject=$2
	if [[ -z "${searchObject// }" ]]; then
		searchObject="*.*"
	fi    

	numberToList=$3
	if [[ -z "${numberToList// }" ]]; then
		numberToList="10"
	fi    

	#pringSepLine 80
	printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
	printf "Showing %s Results \n" "$numberToList"
	#pringSepLine 80


	find $searchPath -iname $searchObject -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberToList"

	#pringSepLine 80
}


#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
function findLatestVersionOfFile()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	searchObject=$2
	# if [[ -z "${searchObject// }" ]]; then
	# 	searchObject="."
	# fi    

	numberToList=$3
	if [[ -z "${numberToList// }" ]]; then
		numberToList="10"
	fi    

	#find $1 -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head

	#pringSepLine 80
	printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
	printf "Showing %s Results \n" "$numberToList"
	#pringSepLine 80


#	find $1 -type f | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
	find $searchPath -name $searchObject -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberToList"

	#pringSepLine 80
}

#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
function findOldestVersionOfFile()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	searchObject=$2
	# if [[ -z "${searchObject// }" ]]; then
	# 	searchObject="."
	# fi    

	numberToList=$3
	if [[ -z "${numberToList// }" ]]; then
		numberToList="10"
	fi  
	#find $1 -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head

	#pringSepLine 80
	printf "Searching %s for OLDEST versions of %s\n" "$searchPath" "$searchObject"
	printf "Showing %s Results \n" "$numberToList"
	#pringSepLine 80

	find $searchPath -name $searchObject -type f | xargs stat --format '%Y :%y %n' | sort -n | cut -d: -f2- | head -n "$numberToList"

	#pringSepLine 80
}

#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
function sudoFindLatestVersionOfFile()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	searchObject=$2
	# if [[ -z "${searchObject// }" ]]; then
	# 	searchObject="."
	# fi    

	numberToList=$3
	if [[ -z "${numberToList// }" ]]; then
		numberToList="10"
	fi    

	#find $1 -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head

	#pringSepLine 80
	printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
	printf "Showing %s Results \n" "$numberToList"
	#pringSepLine 80


#	find $1 -type f | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
	sudo find $searchPath -name $searchObject -type f | sudo xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberToList"

	#pringSepLine 80
}
#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
function sudoFindLatestVersionOfFolder()
{
	searchPath=$1
	searchObject=$2
	numberSearchResults=$3

	if [[ -z "${searchPath// }" ]]; then
		printf "searchPath is empty\n"
	fi    

	if [[ -z "${searchObject// }" ]]; then
		printf "searchObject is empty\n"
	fi    

	if [[ -z "${searchPath// }" ]] || [[ -z "${searchObject// }" ]] || [[ -z "${numberSearchResults// }" ]]; then 
#		printf "\nUsage: %s searchPath searchObject numberSearchResults \n\n" "$FUNCNAME"
		printf "\nUsage: %s searchPath searchObject numberSearchResults \n\n" "$FUNCNAME"

	else
	
		if [[ -z "${numberSearchResults// }" ]]; then
			numberSearchResults="10"
		fi  

		#pringSepLine 80
		printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
		printf "Showing %s Results \n" "$searchResults"
		#pringSepLine 80

#		find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"
		sudo find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"
		#pringSepLine 80

	fi    

}
#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
function findLatestVersionOfFolder()
{
	searchPath=$1
	searchObject=$2
	numberSearchResults=$3

	if [[ -z "${searchPath// }" ]]; then
		printf "searchPath is empty\n"
	fi    

	if [[ -z "${searchObject// }" ]]; then
		printf "searchObject is empty\n"
	fi    

	if [[ -z "${searchPath// }" ]] || [[ -z "${searchObject// }" ]] || [[ -z "${numberSearchResults// }" ]]; then 
#		printf "\nUsage: %s searchPath searchObject numberSearchResults \n\n" "$FUNCNAME"
		printf "\nUsage: %s searchPath searchObject numberSearchResults \n\n" "$FUNCNAME"

	else
	
		if [[ -z "${numberToList// }" ]]; then
			numberToList="10"
		fi  

		#pringSepLine 80
		printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
		printf "Showing %s Results \n" "$searchResults"
		#pringSepLine 80

#		find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"
		find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"
		#pringSepLine 80

	fi    

}

#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
function findOldestVersionOfFolder()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	searchObject=$2

	numberToList=$3
	if [[ -z "${numberToList// }" ]]; then
		numberToList="10"
	fi  

	#pringSepLine 80
	printf "Searching %s for OLDEST versions of %s\n" "$searchPath" "$searchObject"
	printf "Showing %s Results \n" "$numberToList"
	#pringSepLine 80

	find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -n | cut -d: -f2- | head

	#pringSepLine 80
}

#-------------------------------------------------------------------------------
#   find all files in $1 and sort by modification date
#-------------------------------------------------------------------------------
function findAllFilesAndSort()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	#find $1 -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head

	printf "Searching:       %s \n" "$searchPath"
	find $1 -type f | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
}

#-------------------------------------------------------------------------------
#	This dup finder saves time by comparing size first, then md5sum, 
#	it doesn't delete anything, just lists them.
#-------------------------------------------------------------------------------
function findDupesBySizeThenMD5Sum ()
{
	# searchPath=$1
	# if [[ -z "${searchPath// }" ]]; then
	# 	searchPath="."
	# fi    

	# printf "Searching:       %s for binary duplicates \n" "$searchPath"

	find -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate

}


#-------------------------------------------------------------------------------
#	Find all files in $searthPath, then compute md5sum on each
#-------------------------------------------------------------------------------
function findAllFilesThenMD5Sum ()
{
	# find ./ -type f -print0 | xargs -0 md5sum

	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	resultsFile=$2
	if [[ -z "${resultsFile// }" ]]; then
		resultsFile=""
	fi    

	printf "Searching:       %s md5sums saved to %s\n" "$searchPath" "$resultsFile"

	find "$searchPath" -type f -print0 | xargs -0 md5sum >> "$resultsFile"
}


#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function InitializeJSIG4Env()
{
	InitializeContinuumEnv
	InitializeIGStudioEnv
	InitializeOpenSeneGraphEnv
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function latestdir() 
{
src=$1
printf "src dir: %s \n " "$src"
latest=$(find "$src"  -type d   |sort -nr |head -10)
printf "Latest: %s\n" "$latest"
cd $latest

}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function gotonewestdir()                                                        
{                                                                               
  export LOCALPATH=$PWD                                                         
  cd $LOCALPATH                                                                 
  DIRECTORY=$(cd $LOCALPATH; find * -type d -prune -exec ls -d {} \; |tail -1)  

  printf "$DIRECTORY\n"                                                         
  cd $DIRECTORY                                                                 
#  ls -lrt                                                                      
#  FIRST_DIR=`ls -t1F | grep / | head -n1`                                      
#  printf "$FIRST_DIR\n"                                                        
#  DIR="${FIRST_DIR}"                                                           
#  printf "$DIR\n"                                                              
#  cd "$DIR"
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function checkRPath ()
{
	target=$1
	string=$(chrpath -l ${target})
	rpath="${string##*=}"
	echo "------------------------------------------------"
	echo "$target rpath: "
	echo ""
	echo -e ${rpath//:/\\n}
	echo "------------------------------------------------"
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function checkAllRPaths ()
{
	targetDir=$1
	filename="*."$2
	outputfile=$3
	printf "Search %s for all files that match %s \n" "$targetDir" "$filename" 

#	find $targetDir -iname $filename -type f |xargs chrpath -l  | tee $outputfile

#	for i in `find /home/Phil/Programs/Compile -name *.cpp` ; do echo $i ; 
#	done


	for i in ./*.so; do 
    	printf "File:  %s\n" "$i"
    	checkRPath $i
	done

}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function createEmptyScript ()
{
	scriptFile=$1
	createEmptyScript.sh $1
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function createISOFromFolder ()
{

	targetFolder=$1
	isoName="$targetFolder.iso"

	if [[ -f $isoName ]]; then
		printf "%s already exists.... Delete [y]\n" "$isoName"
		read response
		if [ "$response" = "n" ]; then
			exit
		fi 
		rm -rfv $isoName
		printf "\n"
	fi

	printf "Creating %s from %s\n" "$isoName" "$targetFolder"
#	genisoimage -o -joliet-long $isoName $targetFolder
 	mkisofs -iso-level 3 -J -joliet-long -rock -input-charset utf-8 -o $isoName $targetFolder

# 	sudo mount -o loop $1 /mnt/isomount
#	ls /mnt/isomount

}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function htopByProcName ()
{
	procName=$1
	htop -p $(pgrep -d',' -f $procName)
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function topByProcName ()
{
	procName=$1
	top -c -p $(pgrep -d',' -f $procName)
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function listScripts ()
{	
	ls $SCRIPTS/*.sh | xargs -n1 basename
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function checksumFilesInDir ()
{	
	targetDirectory=${1:-$PWD}
	printf "%s: %20s\n" "Target Directory" "${targetDirectory}"

	for file in ${targetDirectory}/*;
	do
		echo $file
		md5sum $file
	done
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function say 
{ 
	mplayer -really-quiet "http://translate.google.com/translate_tts?tl=en&q=$1"; 
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function findLargestNFiles () 
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    
	printf "Searching:                 %s \n" "$searchPath"


	numberToList=$2
	if [[ -z "${numberToList// }" ]]; then
		numberToList="20"
	fi    
	printf "Number of Results To List: %s \n" "$numberToList"

	# searchObject=$3
	# if [[ -z "${searchObject// }" ]]; then
	# 	searchObject="."
	# fi    
	# printf "For Most Recent:           %s \n" "$searchObject"

#	find $searchPath -type f -print0 | xargs -0 du -h | sort -hr | head -20
	find $searchPath -type f -print0 | xargs -0 du -h | sort -hr | head -n "$numberToList"
#	find $searchPath -name $searchObject -type f | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberToList"
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function killallthese ()
{
	procName=$1

	pidsToKill=$(pgrep $procName)

	kill -s 0 $pidsToKill

	if [ $? -eq 0 ]; then

		printf "Attempting to kill processes named %s with PID(s) %s\n" "$procName" "$pidsToKill"

		kill -9 $pidsToKill
		if [ $? -eq 0 ];then
			printf "Succeeded\n"
		else
			printf "FAILED\n"
		fi
	fi
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function findZombieProcess ()
{
	ps -elf | head -1; ps -elf | awk '{if ($5 == 1 && $3 != "root") {print $0}}' | head
}


#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function cheeseyDiscoLights ()
{
	while true; do printf "\e[38;5;$(($(od -d -N 2 -A n /dev/urandom)%$(tput colors)))m.\e[0m"; done
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function replaceInFiles ()
{
	oldString=$1
	newString=$2
	printf "\nReplace \'%s\' with \'%s\' \n\n" "$oldString" "$newString" 
	sed -i -- 's/"$oldString"/"$newString"/g' *
	echo $cmd
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function getAllPDFsFromURL () 
{
	sourceURL=$1
#	wget -r -l1 -A.pdf $sourceURL
	wget --no-check-certificate -r -l1 -A.pdf $sourceURL
#	wget --no-check-certificate -l1 -r -A.pdf https://www.dre.vanderbilt.edu/~schmidt/PDF/
	wget --no-check-certificate -l1 -r -A.pdf $sourceURL

}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function shredIt () 
{
	filesToShred=$1
	echo $filesToShred

	iterations=${2:-8}
	printf -v iterationsArgs '%.0s-' {1..2};
	iterationsArgs+="iterations="${iterations}

	printf -v shredCmd "shred --force --remove --verbose --exact --zero  %s %s " "$iterationsArgs" "$filesToShred"
	printf "%s\n" "$shredCmd"
	eval $shredCmd
}


# #!/bin/bash
# #
# echo "Server test pings issued at $(date)" >> test_ping.log
# for server in google.co.uk amadeup.address.con
# do
#   ping=$(ping -c 2 "$server" 2>&1| grep "% packet" | cut -d" " -f 6 | tr -d "%")
#   if [ "$ping" = "" ]
#   then
#     echo "Server $server not valid"
#   elif [ $ping -eq 100 ]
#   then
#     echo "Server $server not responding"
#   else
#     echo "Server $server has $((100 - ping))% response rate"
#   fi
# done >> test_ping.log
# echo " === Complete ===" >> test_ping.log
# exit

# #-------------------------------------------------------------------------------
# #                                                                               
# #-------------------------------------------------------------------------------
# function renameAllFilesWithSubstring() 
# {
# # Rename all files which contain the sub-string 'foo', replacing it with 'bar'

# # That is an alternative to command 8368.

# # Command 8368 is EXTREMELY NOT clever.

# # 1) Will break also for files with spaces AND new lines in them AND for an empty expansion of the glob '*'

# # 2) For making such a simple task it uses two pipes, thus forking.

# # 3) xargs(1) is dangerous (broken) when processing filenames that are not NUL-terminated.

# # 4) ls shows you a representation of files. They are NOT file names (for simple names, they mostly happen to be equivalent). Do NOT try to parse it.

# # Why? see this :http://mywiki.wooledge.org/ParsingLs

# # Recursive version:
# # find . -depth -name "*foo*" -exec bash -c 'for f; do base=${f##*/}; mv -- "$f" "${f%/*}/${base//foo/bar}"; done' _ {} + 

# # oneliner
# # for f in *; do mv "$f" "${f/foo/bar}"; done
# }
#!/bin/bash

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function gitRecursivePull () 
{
	# find all .git directories and exec "git pull" on the parent.
	find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;
}


#netinfo - shows network information for your system
#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
function netinfo ()
{
	echo "--------------- Network Information ---------------"
	/sbin/ifconfig | awk /'inet addr/ {print $2}'
	/sbin/ifconfig | awk /'Bcast/ {print $3}'
	/sbin/ifconfig | awk /'inet addr/ {print $4}'
	/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
#	myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
#	echo "${myip}"
	echo "---------------------------------------------------"
}


#-------------------------------------------------------------------------------
#                                                                               
# 	explain.sh begins
#	www.tecmint.com/explain-shell-commands-in-the-linux-shell/
#                                                                               
#-------------------------------------------------------------------------------
function explain () 
{
  if [ "$#" -eq 0 ]; then
    while read  -p "Command: " cmd; do
      curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$cmd"
    done
    echo "Bye!"
  elif [ "$#" -eq 1 ]; then
    curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$1"
  else
    echo "Usage"
    echo "explain                  interactive mode."
    echo "explain 'cmd -o | ...'   one quoted command to explain it."
  fi
}



#-------------------------------------------------------------------------------
#                                                                               
# 	createAlias
#
#	Based on:
#	https://medium.com/the-lazy-developer/an-alias-for-new-aliases-c6500ae0f73e#.kpq07d8r7
#                                                                               
#-------------------------------------------------------------------------------
function createAlias() 
{
  local last_command=$(echo `history |tail -n2 |head -n1` | sed 's/[0-9]* //')
  echo $last_command
  echo alias $1="'""$last_command""'" >> ~/bin/scripts/aliases.sh 
  . ~/bin/scripts/aliases.sh 
}
# new-alias() {
#   local last_command=$(echo `history |tail -n2 |head -n1` | sed 's/[0-9]* //')
#   echo alias $1="'""$last_command""'" >> ~/.bash_profile
#   . ~/.bash_profile
# }

# function findAndCopy()
# {
# 	#	This worked, now to genericize it....
# 	#
# 	#	find /z2/shared/tools/AMIE/ -iname '*linux*64*.*' -exec sh -c ' exec cp  /home/peddycoartte/devel/ARCHIVE/' sh {} +
# 	#
# 	#
# }




function howDoIFindExecCopy()
{
# 	find /z2/shared/tools/AMIE/ -iname '*linux*64*.*' -exec sh -c ' exec cp "$@" /home/peddycoartte/devel/ARCHIVE/' sh {} +
	echo "example of how to find * then -exec cp it"
#	echo "find /z2/shared/tools/AMIE/ -iname '*linux*64*.*' -exec sh -c ' exec cp \"\$@" /home/peddycoartte/devel/ARCHIVE/' sh {} +"
	echo "find /path/to/search -iname '*file*name*.type*' -exec sh -c ' exec cp \""\$@\"" /path/to/destination' sh {} +"
}


function whereMounted() 
{

	df -P -T $1 | tail -n +2 | awk '{print $2}'

}

function showAllMountPoints()
{
	searchPath=${1:-$PWD}
	printf "Directory: %s Mount Point: %s\n" "$searchPath" $(df -P -T $searchPath | tail -n +2 | awk '{print $2}')

	for dir in $searchPath/*
	do
    	dir=${dir%*/}
    	# echo ${dir##*/}
    	printf "##########################################\n"
		printf "Directory:   %s\n" "$dir"
		printf "Mount Point: %s\n" $(df -P -T $dir | tail -n +2 | awk '{print $2}')
    	printf "##########################################\n"
	done	
}

function findNFSMounts() 
{
	searchPath=${1:-$PWD}
	printf "Directory: %s Mount Point: %s\n" "$searchPath" $(df -P -T $searchPath | tail -n +2 | awk '{print $2}')

	for dir in $searchPath/*
	do
    	dir=${dir%*/}
    	mountPoint=$(df -P -T $dir | tail -n +2 | awk '{print $2}')
    	isNFS=${mountPoint^^}
    	if [[ $isNFS == "NFS"  ]]; then 
	    	printf "##########################################\n"
			printf "Directory:   %s\n" "$dir"
			printf "Mount Point: %s\n" $(df -P -T $dir | tail -n +2 | awk '{print $2}')
	    	printf "##########################################\n"    		
    	fi

	done	

}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function shredAndRemoveDir () 
{
	printf "!!!!!!!!!!!!!!!!!!!!!!"
	printf "! WARNING NOT TESTED !\n"
	printf "!!!!!!!!!!!!!!!!!!!!!!"
	targetDir=${1:-$PWD}
	find "${targetDir}" -type f -print0 -exec shred --force --remove --verbose --exact --zero -n 8 {} \;
	rmd "${targetDir}"
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function shredDirContents () 
{
	printf "!!!!!!!!!!!!!!!!!!!!!!"
	printf "! WARNING NOT TESTED !\n"
	printf "!!!!!!!!!!!!!!!!!!!!!!"
	targetDir=${1:-$PWD}
	find "${targetDir}" -type f -print0 -exec shred --force --remove --verbose --exact --zero -n 8 {} \;
}

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function showPath() 
{
	# usage: showPath $MY_PATH

    local PATHVARIABLE=${1:-PATH}
	echo -e ${PATHVARIABLE//:/\\n}
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function pathremove () 
{
	# printf "\n"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "Function: %s\n\n" "$FUNCNAME"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "\n\n"

	# usage: 
	#	OLD_PATH="/home/myHome:/home/myHome/bin"
	#	MY_PATH=/home/myHome/bin
	#	pathremove $MY_PATH OLD_PATH
	#	showPath $OLD_PATH

    local IFS=':'
    local NEWPATH
    local DIR
    local PATHVARIABLE=${2:-PATH}

	for DIR in ${!PATHVARIABLE} ; do
		if [ "$DIR" != "$1" ] ; then
			NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
		fi
    done
    export $PATHVARIABLE="$NEWPATH"
}


#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function pathprepend () 
{
	# printf "\n"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "Function: %s\n\n" "$FUNCNAME"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "\n\n"

	# usage: 
	# 	OLD_PATH="/home/myHome:/home/myHome/bin"
	# 	MY_PATH=/home/myHome/Software
	#	pathappend $MY_PATH OLD_PATH
	# 	showPath $OLD_PATH

	pathremove $1 $2
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function pathappend () 
{
	# printf "\n"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "Function: %s\n\n" "$FUNCNAME"
	# printf "%s\n" "------------------------------------------------------------"
	# printf "\n\n"

	# usage: 
	# 	OLD_PATH="/home/myHome:/home/myHome/bin"
	# 	MY_PATH=/home/myHome/proj
	#	pathappend $MY_PATH OLD_PATH
	# 	showPath $OLD_PATH

	pathremove $1 $2
	local PATHVARIABLE=${2:-PATH}
	echo $2
	export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function printDevEnv() 
{
	printf "Printing JSIG5 Environment Variables\n"

	printf "\n"
	#pringSepLine 80
	printf "#  BOOST_Dir:          %s \n" "${BOOST_Dir}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $BOOST_Dir)
	printf "#  BOOST_ROOT:         %s \n" "${BOOST_ROOT}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $BOOST_ROOT)
	printf "#  CONTINUUM:          %s \n" "${CONTINUUM}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $CONTINUUM)
	printf "#  CUDA_PATH:          %s \n" "${CUDA_PATH}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $CUDA_PATH)
	printf "#  CUDA_ROOT:          %s \n" "${CUDA_ROOT}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $CUDA_ROOT)
	printf "#  CUDA_BIN_DIR:       %s \n" "${CUDA_BIN_DIR}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $CUDA_BIN_DIR)
	printf "#  CUDA_LIB_DIR:       %s \n" "${CUDA_LIB_DIR}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $CUDA_LIB_DIR)
	printf "#  IGStudio:           %s \n" "${IGStudio}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $IGStudio)
	printf "#  IGSTUDIO:           %s \n" "${IGSTUDIO}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $IGSTUDIO)
	printf "#  IGSTUDIO_DIR:       %s \n" "${IGSTUDIO_DIR}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $IGSTUDIO_DIR)
	printf "#  JSIG_DATA:          %s \n" "${JSIG_DATA}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $JSIG_DATA)
	printf "#  JSIG_HOME:          %s \n" "${JSIG_HOME}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $JSIG_HOME)
	printf "#  JSIG5_BUILD_DIR:    %s \n" "${JSIG5_BUILD_DIR}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $JSIG5_BUILD_DIR)
	printf "#  OSG_DIR:            %s \n" "${OSG_DIR}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $OSG_DIR)
	printf "#  OSGEARTH_DIR:       %s \n" "${OSGEARTH_DIR}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $OSGEARTH_DIR)
	printf "#  OSG_ROOT:           %s \n" "${OSG_ROOT}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $OSG_ROOT)
	printf "#  TRITON_PATH:        %s \n" "${TRITON_PATH}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $TRITON_PATH)
	printf "#  SILVERLINING_PATH:  %s \n" "${SILVERLINING_PATH}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $SILVERLINING_PATH)
	printf "#  COMMONWRX_ROOT:     %s \n" "${COMMONWRX_ROOT}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $COMMONWRX_ROOT)
	printf "#  TTECLIBS_ROOT:      %s \n" "${TTECLIBS_ROOT}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $TTECLIBS_ROOT)
	printf "#  RFM2G_ROOT:         %s \n" "${RFM2G_ROOT}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $RFM2G_ROOT)
	printf "#  RFM2G_INC:          %s \n" "${RFM2G_INC}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $RFM2G_INC)
	printf "#  RFM2G_LIB:          %s \n" "${RFM2G_LIB}"
	printf "#      Acutal Path:    %s\n" $(readlink -e $RFM2G_LIB)
	#pringSepLine 80


	# #pringSepLine 80
	# printf "PATH\n"
	# showPath $PATH

	# #pringSepLine 80
	# printf "LD_LIBRARY_PATH\n"
	# showPath LD_LIBRARY_PATH

	# #pringSepLine 80
	# printf "OSG_FILE_PATH\n"
	# showPath $OSG_FILE_PATH

	#pringSepLine 80
	printf "PATH\n"
	local PATHVARIABLE=$PATH
	echo -e ${PATHVARIABLE//:/\\n}

	#pringSepLine 80
	printf "LD_LIBRARY_PATH\n"
	local PATHVARIABLE=$LD_LIBRARY_PATH
	echo -e ${PATHVARIABLE//:/\\n}

	#pringSepLine 80
	printf "OSG_FILE_PATH\n"
	local PATHVARIABLE=$OSG_FILE_PATH
	echo -e ${PATHVARIABLE//:/\\n}

	#pringSepLine 80

}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function sortAllFilesByDate()
{
	targetDirectory=${1:-$PWD}
	find $targetDirectory -type f -printf "%-.22T+ %M %n %-8u %-8g %8s %Tx %.8TX %p\n" | sort | cut -f 2- -d ' '
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function findAndGrepXArgs()
{
#	find . -name $1 -print0 | xargs -0 grep $2 > output.txt
	find . -name $1 -print0 | xargs -0 grep $2
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
function findAndGrepExec()
{
#	find . -name $1 -exec grep $2 {} \; > output.txt
	find . -name $1 -exec grep $2 {} \; 
}

# FIND FILES SORT BY MOD DATE/TIME
#find rtsgshare -type f -print0 | xargs -0 stat -c'%Y :%y %12s %n' | sort -nr | cut -d: -f2- | head


#-------------------------------------------------------------
# verify tar file
#-------------------------------------------------------------
function verifyTarFileOLD()
{
	__fileToVerify="${1:-""}"

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "Verifying %s\n" "${__fileToVerify}"
	printf "%s\n" "------------------------------------------------------------"


	if [ -f "${__fileToVerify}" ] ; then
		case "${__fileToVerify}" in

			*.tar)       
				tar xvf  "${__fileToVerify}" -O > /dev/null
				if [ $? -eq 0 ];
				then
					printf " Verification of %s SUCCEEDED\n" "${__fileToVerify}"
				else
					printf " Verification of %s FAILED\n" "${__fileToVerify}"
				fi
				;;

			*.tar.bz2)   
				tar xvjf "${__fileToVerify}" -O > /dev/null
				if [ $? -eq 0 ];
				then
					printf " Verification of %s SUCCEEDED\n" "${__fileToVerify}"
				else
					printf " Verification of %s FAILED\n" "${__fileToVerify}"
				fi
				;;

			*.tar.gz)    
				tar xvzf "${__fileToVerify}" -O > /dev/null
				if [ $? -eq 0 ];
				then
					printf " Verification of %s SUCCEEDED\n" "${__fileToVerify}"
				else
					printf " Verification of %s FAILED\n" "${__fileToVerify}"
				fi
				;;

			*.tbz2)      
				tar xvjf "${__fileToVerify}" -O > /dev/null
				if [ $? -eq 0 ];
				then
					printf " Verification of %s SUCCEEDED\n" "${__fileToVerify}"
				else
					printf " Verification of %s FAILED\n" "${__fileToVerify}"
				fi
				;;

			*.tgz)       
				tar xvzf "${__fileToVerify}" -O > /dev/null
				if [ $? -eq 0 ];
				then
					printf " Verification of %s SUCCEEDED\n" "${__fileToVerify}"
				else
					printf " Verification of %s FAILED\n" "${__fileToVerify}"
				fi
				;;

			*.xz)        
				tar xvJf "${__fileToVerify}" -O > /dev/null
				if [ $? -eq 0 ];
				then
					printf " Verification of %s SUCCEEDED\n" "${__fileToVerify}"
				else
					printf " Verification of %s FAILED\n" "${__fileToVerify}"
				fi
				;;

			*)           
				printf "%s cannot be extracted via >extract<" "${__fileToVerify}" ;;
		esac
	else
		printf "%s is not a valid file" "${__fileToVerify}"
	fi

	printf "\n\n"


}

#-------------------------------------------------------------
# verify tar file
#-------------------------------------------------------------
function verifyTarFile()
{
	__fileToVerify="${1:-""}"

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "Verifying %s\n" "${__fileToVerify}"
	printf "%s\n" "------------------------------------------------------------"

	__tarCommand="tar xvf"

	if [ -f "${__fileToVerify}" ] ; then
		case "${__fileToVerify}" in

			*.tar)       				
				__tarCommand="tar xvf"
				;;

			*.tar.bz2)   
				__tarCommand="tar xvjf"
				;;

			*.tar.gz)    
				__tarCommand="tar xvzf"
				;;

			*.tbz2)      
				__tarCommand="tar xvjf"
				;;
			*.tgz)       
				__tarCommand="tar xvzf"
				;;
			*.xz)        
				__tarCommand="tar xvJf"
				;;

			*)           
				printf "%s cannot be extracted via >extract<" "${__fileToVerify}" ;;
		esac
	else
		printf "%s is not a valid file" "${__fileToVerify}"
	fi

	printf -v __verificationCommand "%s %s -O > /dev/null" "${__tarCommand}" "${__fileToVerify}" 
	eval "${__verificationCommand}"
	
	if [ $? -eq 0 ];
	then
		printf " Verification of %s SUCCEEDED\n" "${__fileToVerify}"
	else
		printf " Verification of %s FAILED\n" "${__fileToVerify}"
	fi

	printf "\n\n"


}

#-------------------------------------------------------------
# List All File Extensions Found In Specified Search Path
#-------------------------------------------------------------
function listFileExtensions()
{

#   find . -type f | awk -F'.' '{print $NF}' | sort| uniq -c | sort -g	

	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    	
	find "${searchPath}" -type f | awk -F'.' '{print $NF}' | sort| uniq -c | sort -g
}

# #-------------------------------------------------------------
# # merge branch $1 into current checkedout branch 
# #-------------------------------------------------------------
# function gitmerge()
# {
# 	local branchToMergeIntoCurrentBranch="${1:develop}"
# 	printf "Branch To Merge Into Current Branch"

# 	//	Show current branch 
# 	currentBranch="$(git branch | grep '\*')"
# 	echo $currentBranch
# 	printf "Merging %s into %s " "${1:branchToMergeIntoCurrentBranch}" "${1:currentBranch}"
# #	read respYN

# #	git merge "${1:branchToMergeIntoCurrentBranch}"
# }

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
function findAndDeleteAllSymLinks()
{
	find -maxdepth 1 -type l -exec unlink {} \;
}

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
function lsDirBySize()
{
	__searchPath=${1:-.}
	printf "Listing Dir Sort By Size: %s\n" "${__searchPath}"
	du --max-depth=1 "${__searchPath}" | sort -n -r
}

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
function listKernels()
{
	sudo egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
}



#-------------------------------------------------------------
# 
#-------------------------------------------------------------
function findAllFileExtensions()
{
	find . -type f | perl -ne 'print $1 if m/\.([^.\/]+)$/' | sort -u
}


#-------------------------------------------------------------
# create directory with date/tag stamps
#-------------------------------------------------------------
function sudoCreateTaggedTimeStampedTar()
{

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "Function: %s\n\n" "$FUNCNAME"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"

	createDateTimeTag

	#	DIR to TAR
	targetDir=$1 

	#	Optional TAG
	tag=$2

	tarFile="$targetDir"."$dateTimeTag"

	if [[ -z "${tag// }" ]]; then
		tarFile="$targetDir"."$dateTimeTag".tar
	else
		tarFile="$targetDir"."$dateTimeTag"."$tag".tar
	fi    

	printf "%s\n" "------------------------------------------------------------"
	printf "Attempting to create: %s\n" "${tarFile}"

	cmd="tar cvzf $tarFile $targetDir"
	printf "Executing %s\n" "$cmd"
	$cmd

	sudo tar -xvf $tarFile -O > /dev/null

	printf "Creation of %s " "$tarFile"
	if [ $? -eq 0 ];
	then
		printf " succeeded\n"
	else
		printf " failed\n"
	fi

	# if [[ -f $tarFile ]]; then
	# 	printf " succeeded\n"
	# else
	# 	printf " failed\n"
	# fi


	printf "%s\n" "------------------------------------------------------------"
}


#-------------------------------------------------------------
# 
#-------------------------------------------------------------
function findInBashHistory()
{
	__stringToFind="${1}"

	if [[ -z "${__stringToFind// }" ]]; then
		printf "String To Find Is Empty\n"
	fi    

	grep "${__stringToFind}" ~/.logs/bash-history*.*
}


#-------------------------------------------------------------
# 
#-------------------------------------------------------------
function showBackupFolders()
{
	#pringSepLine 80	
	printf "Backup Root:   %s\n" "${BACKUP_ROOT}"
	printf "AvSTIL Root:   %s\n" "${AVSTIL_BACKUP_ROOT}"
	printf "AvSTIL Code:   %s\n" "${AVSTIL_CODE_BACKUP}"
	printf "AvSTIL Repos:  %s\n" "${AVSTIL_REPOS_BACKUP}"
	printf "Daily:         %s\n" "${DAILY_BACKUP}"
	#pringSepLine 80
}



#!/bin/sh
# https://chris-lamb.co.uk/posts/can-you-get-cp-to-give-a-progress-bar-like-wget
#cp_p()
function copyWithProgressBar()
{
   strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
      | awk '{
        count += $NF
            if (count % 10 == 0) {
               percent = count / total_size * 100
               printf "%3d%% [", percent
               for (i=0;i<=percent;i++)
                  printf "="
               printf ">"
               for (i=percent;i<100;i++)
                  printf " "
               printf "]\r"
            }
         }
         END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}


#-------------------------------------------------------------
# 
#-------------------------------------------------------------
function showAvailableExportsOnNFSServer()
{
	__server="${1}"
	showmount -e "${__server}"
}

fi
################################################################################
