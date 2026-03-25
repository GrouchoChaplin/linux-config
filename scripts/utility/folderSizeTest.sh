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


find $1 -maxdepth 1 -type d |xargs du -sh * | sort -rh
