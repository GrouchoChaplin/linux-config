#!/bin/bash

#!/bin/bash 

findAllFilesByExtSortBySize()
{
	__targetDir=${1}
	__targetExt=${2}

	 find ${__targetDir} -iname "*.${__targetExt}" -print0 | xargs -0 du -h | sort -hr 

}

#-------------------------------------------------------------------------------
#	Search Path For File, Then Search File For Filename
#-------------------------------------------------------------------------------
findFileThenFindUseOf()
{
	printf "Not Finished... Just here to remind me how to do this\n"	
	find * -iname "*.bin" -exec grep {} ../../ModtranTool/*.cpp \;|wc -l
}

#-------------------------------------------------------------------------------
#	search path $1 find all sym links
#-------------------------------------------------------------------------------
findAllSymLinks()
{
	__targetDir=${1}
	ls -lR "${__targetDir}" | grep ^l
}

#-------------------------------------------------------------------------------
#	search path $1 and sort by number of occurrences of file type
#-------------------------------------------------------------------------------
countFilesByExt()
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
	find $searchPath -type f | sed -n 's/..*\.//p' | sort -f | uniq -ic
	printf "\n\n"
}

#-------------------------------------------------------------------------------
#	search path $1 and count files
#-------------------------------------------------------------------------------
countFiles()
{
	searchPath=$1
	if [[ -z "${searchPath// }" ]]; then
		searchPath="."
	fi    

	printf "\n\n"
	printf "%s\n" "------------------------------------------------------------"
	printf "%s contains %s files\n" "$searchPath" "$(find $searchPath -printf \\n|wc -l)"
	printf "%s\n" "------------------------------------------------------------"
	printf "\n\n"
}

#-------------------------------------------------------------------------------
#   
#	search path $1 and find folder $2 and copy to $3
#   
#-------------------------------------------------------------------------------
findFilesAndCopyTo()
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
		echo $findCommand
		"$findCommand"
	else
		printf "%s Does Not Exist...Aborting\n" "$destination"
	fi

}

#-------------------------------------------------------------------------------
#   
#	search path $1 and find folder $2 and copy to $3
#   
#-------------------------------------------------------------------------------
findFolderAndCopyTo()
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
findLatestVersionOfFileWildCard()
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
	find $searchPath -iname $searchObject -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberToList"

	#pringSepLine 80
}

#-------------------------------------------------------------------------------
#	search path $1 and find latest version of $2, 
#   or if $2 is omitted sort files by date....
#-------------------------------------------------------------------------------
findLatestVersionOfFile()
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
findOldestVersionOfFile()
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
sudoFindLatestVersionOfFile()
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
sudoFindLatestVersionOfFolder()
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
findLatestVersionOfFolder()
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
findOldestVersionOfFolder()
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
findAllFilesAndSort()
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
findDupesBySizeThenMD5Sum ()
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
findAllFilesThenMD5Sum ()
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
findLargestNFiles () 
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
sudoFindLargestNFiles () 
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
	sudo find $searchPath -type f -print0 | xargs -0 du -h | sort -hr | head -n "$numberToList"
#	find $searchPath -name $searchObject -type f | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberToList"
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
findNFSMounts() 
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
findAndGrepXArgs()
{
#	find . -name $1 -print0 | xargs -0 grep $2 > output.txt
	find . -name $1 -print0 | xargs -0 grep $2
}

#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
findAndGrepExec()
{
#	find . -name $1 -exec grep $2 {} \; > output.txt
	find . -name $1 -exec grep $2 {} \; 
}

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
findAndDeleteAllSymLinks()
{
	find -maxdepth 1 -type l -exec unlink {} \;
}


#-------------------------------------------------------------
# 
#-------------------------------------------------------------
findAllFileExtensions()
{
	find . -type f | perl -ne 'print $1 if m/\.([^.\/]+)$/' | sort -u
}

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
findInBashHistory()
{
	__stringToFind="${1}"

	if [[ -z "${__stringToFind// }" ]]; then
		printf "String To Find Is Empty\n"
	fi    

	grep "${__stringToFind}" ~/.logs/bash-history*.*
}
