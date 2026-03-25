################################################################################
#
#!/bin/bash
################################################################################
################################################################################
#
#	script: gitallprojectsFromList.sh
#
#	Description:
#
################################################################################

source ~/bin/scripts/main/functions.sh


#----------------------------------------------------------
#
#
#----------------------------------------------------------

options=""
__outputFile=""
__purgeLocal=0
__repoListFile=AEgisBitBucketRepoList.lst
__verbose=0
while getopts "r:o:phv" Option
do
  case $Option in

  	r) 	__repoListFile=${OPTARG}
		printf "Repo List File: %s\n" "$__repoListFile"
        ;;

    p)	__purgeLocal=1
		printf "Purge Local:    %d\n" "$__purgeLocal"
		;;

	v) __verbose=1				
		printf "Verbose:        %s\n" "$__verbose"
		;;

	o) __outputFile=${OPTARG}		
		printf "Output File: %s\n" "$__outputFile"
		;;

	h) usage 					
		;;
  esac
done
shift $(($OPTIND - 1))


if [ -n "${__outputFile}" ]; then
	printf "Save stdout and stderr to file descriptors 3 and 4, then redirect them to %s\n" "$outputFile"
	exec 3>&1 4>&2 >$__outputFile 2>&1
fi

__repoBaseAEgis=ssh://git@monkey.bluehalo.com:7999
__repoBaseDI2E=ssh://git@bitbucket.di2e.net:7999

while IFS=':' read -r __groupName __repoName __targetDirName
do

	__dirName=${__groupName//[[:blank:]]/}

	if [[ "$__dirName" == *"#"* ]]; then
	  printf "Skipping line... %s:%s:%s \n" "$__groupName" "$__repoName" "$__targetDirName" #> /dev/null 2\>\&1
	else

		if (( $__purgeLocal )); then 
			printf "Purging %s\n" "$dirName"
			rm -rvf $__dirName
		else

			__repoBaseAEgis=ssh://git@monkey.bluehalo.com:7999

 			shopt -s nocasematch
 			case "${__groupName}" in

 				"scenegen"|"epeddycoart" ) 
 					__reposBase="${__repoBaseAEgis}"
 					;;

 			 	"DI2E" ) 
 					__reposBase="${__repoBaseDI2E}"
 					;;

 			 	*) echo "no match";;
 			esac

			__repoURL=${__reposBase}/"${__repoName}" 

	 		printf "\n%s\n" "-------------------------------------------------------------------------------------------"
		
			printf "Group Name: %s\n" "${__groupName}"
			printf "Repo Name:  %s\n" "${__repoName}"
			printf "Target Dir: %s\n" "${__targetDirName}"
			printf "Repo URL:   %s\n" "${__repoURL}"

			if [[ ! -d "${__groupName}" ]]; then
				printf "%s Does Not Exist \n" "${__groupName}"
				mkdir -p "${__groupName}"
			fi

			pushd "${__groupName}"

	 			git clone "${__repoURL}" "${__targetDirName}"

	 		popd 

 			printf "\n%s\n" "-------------------------------------------------------------------------------------------"
		
 		fi 
	fi

done <"${__repoListFile}"

if [ -n "$__outputFile" ]; then
	exec 1>&3 2>&4
	printf "Restore stdout and stderr\n"
fi












