createTaggedTimeStampedTarSHA256()
{   

    #   Create string with data and time store in envar 'currentDateTime'
    currentDateTime=$(date "+%Y_%m_%d_T%H_%M_%S")

    _timeTag="${currentDateTime}"

    #   Dir to tar
    _targetDir=$1 

    #   string to add as tag in filename
    _tag=$2

    #   initial tar filename base
    _tarFile="${_targetDir}"."${currentDateTime}"


    printf "Target Dir:     %s\n" "${_targetDir}"
    printf "Date/Time Tag:  %s\n" "${_timeTag}"
    printf "Tag:            %s\n" "${_tag}"
    printf "Tar File Base:  %s\n" "${_tarFile}"

    #   if tag not empty, append to filename
    if [[ -n "${_tag// }" ]]; then
        _tarFile="${_targetDir}"."$_tag"."$currentDateTime".tar.gz 
    else
        _tarFile="${_targetDir}"."$currentDateTime".tar.gz
    fi    

    printf "Create:         %s\n" "${_tarFile}"


    cmd="tar -cvzf ${_tarFile} ${_targetDir} -O > /dev/null"
    printf "\n"
    printf "Executing %s\n" "$cmd"
    printf "\n"
    ${cmd}


    printf "Creation of %s " "${_tarFile}"
    if [ $? -eq 0 ];
    then
        printf " succeeded\n"
    else
        printf " failed\n"
    fi

    verifyTarFile "${_tarFile}"

    _sha256InfoFile="${_tarFile}"."sha256"

    printf "SHA256 Info Filename: %s" "${_sha256InfoFile}"


    printf "compute sha256sum\n"
    sha256sum "${_tarFile}" >> "${_sha256InfoFile}"
    printf "Check sha256sum\n"
    sha256sum -c "${_sha256InfoFile}"

}