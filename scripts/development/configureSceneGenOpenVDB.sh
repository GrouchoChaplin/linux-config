#!/bin/env bash


[ $# -eq 0 ] && { echo "Usage: $0 source-dir"; exit 1; }


_sourceDir=${1}
_sourcePath="${PWD}/${_sourceDir}"

echo
echo "[configure] Source Path:      ${_sourcePath}"

 
if [ -d "${_sourcePath}" -a ! -h "${_sourcePath}" ]
then
   echo "${_sourcePath} found..." > /dev/null
else
   echo "[configure]Error: ${_sourcePath} not found or is symlink to $(readlink -f ${_sourcePath})."
   exit 1;
fi


_buildPath="${_sourcePath}-build"
echo "[configure] Build Path:       ${_buildPath}"

_buildType=${2:-"Release"}
echo "[configure] Build Type:       ${_buildType}"

_thirdParthPath=${3}
echo "[configure] 3rdParty Path:    ${_thirdParthPath}"

_freeProcs=3


_update="y"
if [ -d "${_buildPath}" ]; then
    echo "[configure] ${_buildPath} already exists.  Would you like to overwrite/update ${_buildPath}? (y/n)"
    read _update
fi

if [ "$_update" == "y" ]; then

    echo "[configure] configure will attempt to create build directory: ${_buildPath}"
    mkdir -p "${_buildPath}"
    if [ ! -d "${_buildPath}" ]; then
        echo "[configure] Unable to create BUILD_DIR: ${_buildPath}"
        exit 2;
    fi

	echo ${_buildPath}/3rdParty
      
    pushd ${_buildPath} > /dev/null

    	rm -rfv CMakeCache.txt

		ln -svnf  ${_thirdParthPath} ${_buildPath}
		ls -ls ${_buildPath}

	    pushd ${_buildPath}/3rdParty > /dev/null
	    	source ./setVDBDependencies.sh
		popd

		 cmake ${_sourcePath}\
		 		-DCMAKE_BUILD_TYPE=${_buildType}\
		 		-DCMAKE_INSTALL_PREFIX=${_installPath}\
				-DOPENVDB_BUILD_NANOVDB:BOOL=ON\
				-DOPENVDB_BUILD_UNITTESTS:BOOL=ON\
				-DOPENVDB_BUILD_VDB_LOD:BOOL=ON\
				-DOPENVDB_BUILD_VDB_PRINT:BOOL=ON\
				-DOPENVDB_BUILD_VDB_RENDER:BOOL=ON\
				-DOPENVDB_BUILD_VDB_VIEW:BOOL=ON\
				-DOPENVDB_BUILD_BINARIES:BOOL=ON\
				-DOPENVDB_BUILD_CORE:BOOL=ON\
				-DOPENVDB_BUILD_DOCS:BOOL=OFF\
				-DUSE_NANOVDB=ON\
				-DNANOVDB_USE_BLOSC:BOOL=ON\
				-DNANOVDB_USE_CUDA:BOOL=ON\
				-DNANOVDB_USE_INTRINSICS:BOOL=ON\
				-DNANOVDB_USE_MAGICAVOXEL:BOOL=OFF\
				-DNANOVDB_USE_OPENVDB:BOOL=ON\
				-DNANOVDB_USE_TBB:BOOL=ON\
				-DNANOVDB_USE_ZLIB:BOOL=ON\
				-DNANOVDB_ALLOW_FETCHCONTENT:BOOL=ON\
				-DNANOVDB_BUILD_BENCHMARK:BOOL=ON\
				-DNANOVDB_BUILD_EXAMPLES:BOOL=ON\
				-DNANOVDB_BUILD_TOOLS:BOOL=ON\
				-DNANOVDB_BUILD_UNITTESTS:BOOL=ON\
				-DNANOVDB_CUDA_KEEP_PTX:BOOL=ON


		__currentTime=$(date "+%Y_%m_%d_T%H_%M_%S")
		__makeOutputFilename=make_output_${__currentTime}.txt

		_numProc=$(nproc)
		_numMakeProc=$(( _numProc - _freeProcs ))
			
		printf -v makeCmd "make \055j %d " ${_numMakeProc}
		echo "Executing: ${makeCmd}"

		eval ${makeCmd}


    popd

else
    echo "[configure] .................Canceling Configure................."
fi



