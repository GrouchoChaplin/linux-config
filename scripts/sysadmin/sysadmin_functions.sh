#!/bin/bash

#-------------------------------------------------------------
#
#-------------------------------------------------------------
addToPath()
{
	printf "Adding %s to PATH\n" ${PWD}
	export PATH=${PWD}:${PATH}
}

#-------------------------------------------------------------
#
#-------------------------------------------------------------
addToLibPath()
{
	printf "Adding %s to LD_LIBRARY_PATH\n" ${PWD}
	export LD_LIBRARY_PATH=${PWD}:${LD_LIBRARY_PATH}
}

#-------------------------------------------------------------
# 	change user/group ownership of $1 to current user/group
#-------------------------------------------------------------
allMineDir()
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
allmine()
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
# 	change group ownership of $1 to current user/group
#-------------------------------------------------------------
mygroup()
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


#-------------------------------------------------------------
# 	change user/group ownership of $1 to current user/group
#-------------------------------------------------------------
vallmine()
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

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
htopByProcName ()
{
	procName=$1
	htop -p $(pgrep -d',' -f $procName)
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
topByProcName ()
{
	procName=$1
	top -c -p $(pgrep -d',' -f $procName)
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
killallthese ()
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
findZombieProcess ()
{
	ps -elf | head -1; ps -elf | awk '{if ($5 == 1 && $3 != "root") {print $0}}' | head
}

