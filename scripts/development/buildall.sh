#!/bin/env bash 

__numProc=$(nproc)
__numMakeProc=__numProc
((__numMakeProc--))

build()
{
	__jsigSource=$1
	__buildDir=${__jsigSource}-build
	__buildType=${2^^}
	__osgDebug=${3^^}
	__buildTests=${4^^}
	__configLogFilename=$PWD/config."${__buildType}"."${__osgDebug}".txt
	__buildLogFilename=$PWD/build."${__buildType}"."${__osgDebug}".txt
	__ctestLogFilename=$PWD/ctest."${__buildType}"."${__osgDebug}".txt

	echo "###############################################################"
	echo "JSIG Source:     ${__jsigSource}"
	echo "Build Directory: ${__buildDir}"
	echo "Build Type:      ${__buildType}"
	echo "OSG_DEBUG:       ${__osgDebug}"
	echo "Config Log File: ${__configLogFilename}"
	echo "Build Log File:  ${__buildLogFilename}"
	echo "CTest Log File:  ${__ctestLogFilename}"
	echo "---------------------------------------------------------------"

	rm -rvf "${__configLogFilename}"
	rm -rvf "${__buildLogFilename}"
	rm -rvf "${__ctestLogFilename}"

	# rm -rfv ${__buildDir}/*

	pushd ${__jsigSource}
		echo "Current Directory: ${PWD}"
		python deptool.py --verbose  tee ${__configLogFilename}
	 	source ./configure 2>&1 | tee --append ${__configLogFilename}
	popd

	pushd ${__buildDir}		
		echo "Current Directory: ${PWD}" 2>&1 | tee  ${__buildLogFilename}

		rm -rfv CMakeCache.txt  2>&1 | tee --append ${__buildLogFilename}

	 	printf -v cmd "cmake %s -DCMAKE_BUILD_TYPE=%s -DOSG_DEBUG=%s -DBUILD_TESTS=%s -Wno-dev" "${__jsigSource}" "${__buildType}" "${__osgDebug}" "${__buildTests}"
		echo "Executing ${cmd}"  2>&1 | tee --append ${__buildLogFilename}
		eval ${cmd}	 2>&1 | tee --append ${__buildLogFilename}

		grep BUILD_TYPE CMakeCache.txt 2>&1 | tee --append ${__buildLogFilename}
		grep OSG_DEBUG CMakeCache.txt  2>&1 | tee --append ${__buildLogFilename}
		grep BUILD_TESTS CMakeCache.txt  2>&1 | tee --append ${__buildLogFilename}

		make -j  "${__numMakeProc}"   2>&1 | tee --append ${__buildLogFilename}
		ctest  2>&1 | tee ${__ctestLogFilename}
	popd
	echo "###############################################################"	
}

build "${PWD}"/JSIG debug ON  ON
build "${PWD}"/JSIG debug OFF ON
build "${PWD}"/JSIG release ON  ON
build "${PWD}"/JSIG release OFF ON
