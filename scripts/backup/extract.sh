#!/bin/bash

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

# https://ostechnix.com/a-bash-function-to-extract-file-archives-of-various-types/
# # Bash Function To Extract File Archives Of Various Types
# extract () {
#      if [ -f $1 ] ; then
#          case $1 in
#              *.tar.bz2)   tar xjf $1     ;;
#              *.tar.gz)    tar xzf $1     ;;
#              *.bz2)       bunzip2 $1     ;;
#              *.rar)       rar x $1       ;;
#              *.gz)        gunzip $1      ;;
#              *.tar)       tar xf $1      ;;
#              *.tbz2)      tar xjf $1     ;;
#              *.tgz)       tar xzf $1     ;;
#              *.zip)       unzip $1       ;;
#              *.Z)         uncompress $1  ;;
#              *.7z)        7z x $1    ;;
#              *)           echo "'$1' cannot be extracted via extract()" ;;
#          esac
#      else
#          echo "'$1' is not a valid file"
#      fi
# }