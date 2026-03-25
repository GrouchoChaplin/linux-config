# .bashrc


export SCRIPTS_DIR=${HOME}/bin/scripts/
export PATH=${SCRIPTS_DIR}/backup:${PATH}
export PATH=${SCRIPTS_DIR}/git:${PATH}
export PATH=${SCRIPTS_DIR}/jsig:${PATH}
export PATH=${SCRIPTS_DIR}/search:${PATH}
export PATH=${SCRIPTS_DIR}/sublime:${PATH}
export PATH=${SCRIPTS_DIR}/sysadmin:${PATH}
export PATH=${SCRIPTS_DIR}/utility:${PATH}
export PATH=${SCRIPTS_DIR}/yum:${PATH}


# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

shopt -s direxpand
complete -D -o default


# User specific aliases and functions

# alias hdfview='flatpak run org.hdfgroup.HDFView'

#alias websiteDownload='wget --random-wait -r -p -e robots=off -U mozilla ${1}'


alias cls='printf "\33[2J"';

alias readpdf='evince $1'
# The 'ls' family (this assumes you use a recent GNU ls)
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

alias rmd='rm -rfv'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'  # -> Prevents accidentally clobbering files.

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias df='df -kT'
alias mountcol='mount |column -t'
alias mount='mount |column -t'

#   git Related
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

#   Permissions
alias getfp='stat -c "%n %a %A %F" $1'

#   Development related
alias sublime='subl'
alias fastDelete='$HOME/bin/scripts/utility/fastDelete.sh '
alias checkCMakeOptions='egrep "BUILD_TYPE|BUILD_TESTS|ENABLE_COVERAGE|BUILD_DOCS|BUILD_WITH_CUDA|OSG_DEBUG" CMakeCache.txt'
alias checkCMakeTools='egrep "CMAKE_C_COMPILER|BUILD_WITH_CUDA|FORCE_3RDPARTY|CMAKE_INSTALL_PREFIX:PATH=|OSG_DEBUG" CMakeCache.txt'
alias updateNOW='export NOW=$(genDateTime) && echo $NOW'
alias sortDirFilesByDate="find  -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | head"
alias shredIt='shred --force --remove --verbose --exact --zero $1 $2' 

alias vscodecss="code --enable-proposed-api be5invis.vscode-custom-css"

folderSizes () 
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


    printf "Folder Size for %s\n" "$searchPath"
    printf -v cmd "find %s -maxdepth 1 -type d |xargs du -sh * | sort -rh " "$searchPath"
    printf "CMD: %s\n" "${cmd}"
    eval "${cmd}"
}

# verifyTarFile()
# {
#     __fileToVerify="${1:-""}"

#     printf "\n\n"
#     printf "%s\n" "------------------------------------------------------------"
#     printf "Function: %s\n\n" "$FUNCNAME"
#     printf "Verifying %s\n" "${__fileToVerify}"
#     printf "%s\n" "------------------------------------------------------------"

#     __tarCommand="tar xvf"

#     if [ -f "${__fileToVerify}" ] ; then
#         case "${__fileToVerify}" in

#             *.tar)                      
#                 __tarCommand="tar xvf"
#                 ;;

#             *.tar.bz2)   
#                 __tarCommand="tar xvjf"
#                 ;;

#             *.tar.gz)    
#                 __tarCommand="tar xvzf"
#                 ;;

#             *.tbz2)      
#                 __tarCommand="tar xvjf"
#                 ;;
#             *.tgz)       
#                 __tarCommand="tar xvzf"
#                 ;;
#             *.xz)        
#                 __tarCommand="tar xvJf"
#                 ;;

#             *)           
#                 printf "%s cannot be extracted via >extract<" "${__fileToVerify}" ;;
#         esac
#     else
#         printf "%s is not a valid file" "${__fileToVerify}"
#     fi

#     printf -v __verificationCommand "%s %s -O > /dev/null" "${__tarCommand}" "${__fileToVerify}" 
#     eval "${__verificationCommand}"
    
#     if [ $? -eq 0 ];
#     then
#         printf " Verification of %s SUCCEEDED\n" "${__fileToVerify}"
#     else
#         printf " Verification of %s FAILED\n" "${__fileToVerify}"
#     fi

#     printf "\n\n"


# }


# #
# # Handy Extract Program.
# #
# extract()
# {
#     FileToExtract=$1
 
#     if [ -f $FileToExtract ] ; then
#         case $FileToExtract in
#             *.7z)        7za x $1        ;;
#             *.bz2)       bunzip2 $1      ;;
#             *.gz)        gunzip $1       ;;
#             *.rar)       unrar x $1      ;;
#             *.tar)       tar xvf $1      ;;
#             *.tar.bz2)   tar xvjf $1     ;;
#             *.tar.gz)    tar xvzf $1     ;;
#             *.tbz2)      tar xvjf $1     ;;
#             *.tgz)       tar xvzf $1     ;;
#             *.zip)       unzip $1        ;;
#             *.xz)        tar xvJf $1     ;;
#             *.Z)         uncompress $1   ;;
#             *)           echo "'$FileToExtract' cannot be extracted via >extract<" ;;
#         esac
#     else
#         echo "'$FileToExtract' is not a valid file"
#     fi

# }



findLatestVersionOfFile()
{
    searchPath=$1
    if [[ -z "${searchPath// }" ]]; then
        searchPath="."
    fi    

    searchObject=$2    
    numberSearchResults=${3:-10}

    printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
    printf "Showing %s Results \n" "$numberSearchResults"
    #pringSepLine 80


    find $searchPath -name $searchObject -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"

    #pringSepLine 80
}


sudoFindLatestVersionOfFile()
{
    searchPath=${1:-"${PWD}"}
    searchObject=$2
    numberSearchResults=${3:-10}

    printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
    printf "Showing %s Results \n" "$numberToList"
    sudo find $searchPath -name $searchObject -type f | sudo xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"

}

findLatestVersionOfFileWildCard()
{
    searchPath=${1:-"${PWD}"}
    searchObject=$2    
    numberSearchResults=${3:-10}

    printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
    printf "Showing %s Results \n" "$numberToList"

    find $searchPath -iname $searchObject -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"
}

sudoFindLatestVersionOfFileWildCard()
{
    searchPath=${1:-"."}
    searchObject=$2    
    numberSearchResults=${3:-10}

    printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
    printf "Showing %s Results \n" "$numberToList"

    sudo find $searchPath -iname $searchObject -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"
}


findLatestVersionOfFolder()
{
    searchPath=$1
    searchObject=$2
    numberSearchResults=${3:-10}

    if [[ -z "${searchPath// }" ]]; then
        printf "searchPath is empty\n"
    fi    

    if [[ -z "${searchObject// }" ]]; then
        printf "searchObject is empty\n"
    fi    

    if [[ -z "${searchPath// }" ]] || [[ -z "${searchObject// }" ]] || [[ -z "${numberSearchResults// }" ]]; then 
        printf "\nUsage: %s searchPath searchObject numberSearchResults \n\n" "$FUNCNAME"

    else
    
        if [[ -z "${numberToList// }" ]]; then
            numberToList="10"
        fi  

        printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
        printf "Showing %s Results \n" "$searchResults"

        find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"

    fi    

}

sudoFindLatestVersionOfFolder()
{
    searchPath=$1
    searchObject=$2
    numberSearchResults=${3:-10}

    if [[ -z "${searchPath// }" ]]; then
        printf "searchPath is empty\n"
    fi    

    if [[ -z "${searchObject// }" ]]; then
        printf "searchObject is empty\n"
    fi    

    if [[ -z "${searchPath// }" ]] || [[ -z "${searchObject// }" ]] || [[ -z "${numberSearchResults// }" ]]; then 
        printf "\nUsage: %s searchPath searchObject numberSearchResults \n\n" "$FUNCNAME"

    else
    
        if [[ -z "${numberSearchResults// }" ]]; then
            numberSearchResults="10"
        fi  

        #pringSepLine 80
        printf "Searching %s for LATEST versions of %s\n" "$searchPath" "$searchObject"
        printf "Showing %s Results \n" "$searchResults"
        #pringSepLine 80

        sudo find $searchPath -name $searchObject -type d | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head -n "$numberSearchResults"

    fi    

}


#-------------------------------------------------------------
# create date/time stamp with option tag
#-------------------------------------------------------------
genDateTime()
{
    currentTime=$(date "+%Y_%m_%d_T%H_%M_%S")
    echo  $currentTime
}

# #-------------------------------------------------------------
# # create date/time stamp with option tag
# #-------------------------------------------------------------
# genDateTag()
# {
#     currentDate=$(date "+%Y_%m_%d")
#     echo  $currentDate
# }


#-------------------------------------------------------------
#       change user/group ownership of $1 to current user/group
#-------------------------------------------------------------
vallmine()
{
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


createDateTimeTag()
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
createTaggedTimeStampedTar()
{

    createDateTimeTag

    # folder to put tar into
    destinationFolder="$1/"
    echo "Destination Folder: $destinationFolder"    

    # folder to tar
    folderToArchive=$2 
    echo "Folder To Archive: $folderToArchive"    

    #   Optional TAG
    tag=$3
    echo "Tag: $tag"    

    tarFilePath="$destinationFolder""$folderToArchive"."$dateTimeTag"


    if [[ -z "${tag// }" ]]; then
        tarFilePath="$tarFilePath".tar
    else
        tarFilePath="$tarFilePath"."$tag".tar

    fi    

    echo "tar FilePath $tarFilePath"

    printf "%s\n" "------------------------------------------------------------"
    printf "Attempting to create: %s\n" "${tarFilePath}"

    cmd="tar cvzf $tarFilePath $folderToArchive"
    printf "Executing %s\n" "$cmd"
    $cmd

    tar -xvf $tarFilePath -O > /dev/null

    printf "Creation of %s " "$tarFilePath"
    if [ $? -eq 0 ];
    then
        printf " succeeded\n"
    else
        printf " failed\n"
    fi

    verifyTarFile $tarFilePath

    printf "%s\n" "------------------------------------------------------------"
}


# #-------------------------------------------------------------
# # create directory with date/tag stamps
# #-------------------------------------------------------------
# createTaggedTimeStampedSplitTarGZ()
# {

# #   tar cvzf - TTEC/ | split --bytes=512MB - TTEC.backup.tar.gz.

#     printf "\n\n"
#     printf "%s\n" "------------------------------------------------------------"
#     printf "Function: %s\n\n" "$FUNCNAME"
#     printf "%s\n" "------------------------------------------------------------"
#     printf "\n\n"

#     createDateTimeTag

#     #   DIR to TAR
#     targetDir=$1 

#     splitSize=$2

#     #   Optional TAG
#     tag=$3

#     tarFile="$targetDir"."$dateTimeTag"

#     if [[ -z "${tag// }" ]]; then
#         tarFile="$targetDir"."$dateTimeTag".tar.gz"."
#     else
#         tarFile="$targetDir"."$dateTimeTag"."$tag".tar.gz"."
#     fi    

#     printf "%s\n" "------------------------------------------------------------"
#     printf "Attempting to create: %s\n" "${tarFile}"

#     printf -v cmd "tar cvzf - %s | split --bytes=%sMB - %s" "${targetDir}" "${splitSize}" "${tarFile}"
#     printf "Executing %s\n" "$cmd"
#     $cmd


#     printf "%s\n" "------------------------------------------------------------"
# }

# #-------------------------------------------------------------
# # create directory with date/tag stamps
# #-------------------------------------------------------------
# createTaggedTimeStampedTarGZ()
# {

#     printf "\n\n"
#     printf "%s\n" "------------------------------------------------------------"
#     printf "Function: %s\n\n" "$FUNCNAME"
#     printf "%s\n" "------------------------------------------------------------"
#     printf "\n\n"

#     createDateTimeTag

#     #   DIR to TAR
#     targetDir=$1 

#     #   Optional TAG
#     tag=$2

#     tarFile="$targetDir"."$dateTimeTag"

#     if [[ -z "${tag// }" ]]; then
#         tarFile="$targetDir"."$dateTimeTag".tar.gz
#     else
#         tarFile="$targetDir"."$dateTimeTag"."$tag".tar.gz
#     fi    

#     printf "%s\n" "------------------------------------------------------------"
#     printf "Attempting to create: %s\n" "${tarFile}"

#     cmd="tar cvzf $tarFile $targetDir"
#     printf "Executing %s\n" "$cmd"
#     $cmd

#     tar -xvzf $tarFile -O > /dev/null

#     printf "Creation of %s " "$tarFile"
#     if [ $? -eq 0 ];
#     then
#         printf " succeeded\n"
#     else
#         printf " failed\n"
#     fi

#     # if [[ -f $tarFile ]]; then
#     #   printf " succeeded\n"
#     # else
#     #   printf " failed\n"
#     # fi


#     printf "%s\n" "------------------------------------------------------------"
# }

# #-------------------------------------------------------------
# # create directory with date/tag stamps
# #-------------------------------------------------------------
# createTaggedTimeStampedTarXZ()
# {

#     printf "\n\n"
#     printf "%s\n" "------------------------------------------------------------"
#     printf "Function: %s\n\n" "$FUNCNAME"
#     printf "%s\n" "------------------------------------------------------------"
#     printf "\n\n"

#     createDateTimeTag

#     #   DIR to TAR
#     targetDir=$1 

#     #   Optional TAG
#     tag=$2

#     tarFile="$targetDir"."$dateTimeTag"

#     if [[ -z "${tag// }" ]]; then
#         tarFile="$targetDir"."$dateTimeTag".tar.xz
#     else
#         tarFile="$targetDir"."$dateTimeTag"."$tag".tar.xz
#     fi    

#     printf "%s\n" "------------------------------------------------------------"
#     printf "Attempting to create: %s\n" "${tarFile}"

#     cmd="tar cvJf $tarFile $targetDir"
#     printf "Executing %s\n" "$cmd"
#     $cmd

#     tar -xvJf $tarFile -O > /dev/null

#     printf "Creation of %s " "$tarFile"
#     if [ $? -eq 0 ];
#     then
#         printf " succeeded\n"
#     else
#         printf " failed\n"
#     fi

#     # if [[ -f $tarFile ]]; then
#     #   printf " succeeded\n"
#     # else
#     #   printf " failed\n"
#     # fi


#     printf "%s\n" "------------------------------------------------------------"
# }

# createTaggedTimeStampedTarSHA256()
# {   

#     #   Create string with data and time store in envar 'currentDateTime'
#     currentDateTime=$(date "+%Y_%m_%d_T%H_%M_%S")

#     _timeTag="${currentDateTime}"

#     #   Dir to tar
#     _targetDir=$1 

#     #   string to add as tag in filename
#     _tag=$2

#     #   initial tar filename base
#     _tarFile="${_targetDir}"."${currentDateTime}"


#     printf "Target Dir:     %s\n" "${_targetDir}"
#     printf "Date/Time Tag:  %s\n" "${_timeTag}"
#     printf "Tag:            %s\n" "${_tag}"
#     printf "Tar File Base:  %s\n" "${_tarFile}"

#     #   if tag not empty, append to filename
#     if [[ -n "${_tag// }" ]]; then
#         _tarFile="${_targetDir}"."$_tag"."$currentDateTime".tar.gz 
#     else
#         _tarFile="${_targetDir}"."$currentDateTime".tar.gz
#     fi    

#     printf "Create:         %s\n" "${_tarFile}"


#     cmd="tar -cvzf ${_tarFile} ${_targetDir} -O > /dev/null"
#     printf "\n"
#     printf "Executing %s\n" "$cmd"
#     printf "\n"
#     ${cmd}


#     printf "Creation of %s " "${_tarFile}"
#     if [ $? -eq 0 ];
#     then
#         printf " succeeded\n"
#     else
#         printf " failed\n"
#     fi

#     verifyTarFile "${_tarFile}"

#     _sha256InfoFile="${_tarFile}"."sha256"

#     printf "SHA256 Info Filename: %s" "${_sha256InfoFile}"


#     printf "compute sha256sum\n"
#     sha256sum "${_tarFile}" >> "${_sha256InfoFile}"
#     printf "Check sha256sum\n"
#     sha256sum -c "${_sha256InfoFile}"

# }


# path() 
# {
#     echo -e ${PATH//:/\\n}
# }

# libpath() 
# {
#     echo -e ${LD_LIBRARY_PATH//:/\\n}
# }

# filepath() 
# {
#     echo -e ${OSG_FILE_PATH//:/\\n}
# }

# paths()
# {
#     path
#     libpath
#     filepath
# }


export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/BASH/bash-history-$(date "+%Y-%m-%d").log; fi'

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="[\u@\h \W]\$(git_branch)\$ "


#
# Do you wish to update your shell profile to automatically initialize conda?
# This will activate conda on startup and change the command prompt when activated.
# If you'd prefer that conda's base environment not be activated on startup,
#    run the following command when conda is activated:
#
# conda config --set auto_activate_base false
#
# You can undo this by running `conda init --reverse $SHELL`? [yes|no]
#


#export ${HOME}/anaconda3/bin:${HOME}/projects/3rdParty/anaconda3/bin:${HOME}/projects/3rdParty/anaconda3/condabin/:$PATH
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('${HOME}/projects/3rdParty/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "${HOME}/projects/3rdParty/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "${HOME}/projects/3rdParty/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="${HOME}/projects/3rdParty/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<


export CUDA_PATH="/usr/local/cuda"
export CUDA_BIN_PATH="${CUDA_PATH}/bin"
export CUDA_LIB="${CUDA_PATH}/lib64"
export PATH="${CUDA_BIN}":"${PATH}"
export LD_LIBRARY_PATH="${CUDA_LIB}":"${LD_LIBRARY_PATH}"

# export LIBGL_XCB_THREADS=1
# export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/usr/local/hdf5/lib/pkgconfig
# export PATH=/usr/local/automake/bin:$PATH
# export PKG_CONFIG_PATH=/usr/local/netcdf/lib/pkgconfig:/usr/local/hdf5/lib/pkgconfig
# export PKG_CONFIG_PATH=/usr/local/netcdf/lib/pkgconfig:/usr/local/hdf5/lib/pkgconfig:/usr/lib64/pkgconfig

    
export FLUTTER_ROOT="$HOME/projects/3rdParty/flutter"
export PATH="$FLUTTER_ROOT/bin:$PATH"

export HISTTIMEFORMAT="%F %T "

export PATH=$PATH:"$HOME/.local/bin"

export PATH=$PATH:"$HOME/Software/VSCode-CSS/bin"

export UNUSED_PROCS=8

export PARALLEL_WILL_CITE=1


# Load my git branch search helper
if [ -f "$HOME/projects/scripts/git/git_branch_search.sh" ]; then
    source "$HOME/projects/scripts/git/git_branch_search.sh"
fi

# Load Git branch search tab completion if available
if [ -f "$HOME/projects/scripts/git/git_branch_search_completion.sh" ]; then
    source "$HOME/projects/scripts/git/git_branch_search_completion.sh"
fi
