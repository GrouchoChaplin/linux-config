#!/bin/bash 

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
usage()
{
	__scriptName=${0##*/}
	printf "Usage %s \n" "${__scriptName}"
	printf "\t%s-b  <branchname>\n"
	printf "\t%s-l  delete local branch\n"
	printf "\t%s-r  delete remote branch\n"	
	exit 1
}

if [ $# -lt 1 ]; then 
	usage
fi

__deleteLocal=0
__deleteRemote=0
__branchToDelete=""

while getopts ":blr" Option
do
  case $Option in

    b) 	__branchToDelete=${OPTARG%/} 
		;;

    l) 	__deleteLocal=1					
echo $__deleteLocal
		;;

    r) 	__deleteRemove=1	
echo $__deleteRemote
		;;

	h) 	usage ;;
  esac
done
shift $(($OPTIND - 1))

printf "Branch To Delete: %s\n" "${__branchToDelete}"
printf "Delete Local: %s\n" "${__deleteLocal}"
printf "Delete Remote: %s\n" "${__deleteRemote}"

# git push --delete <remote_name> <branch_name>
# git branch -d <branch_name>