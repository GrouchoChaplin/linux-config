#!/bin/env bash 

source ./configure.env 

__numProc=${1:-1}
__forceRebuild=$2
__currentTime=$(date "+%Y_%m_%d_T%H_%M_%S")
__makeOutputFilename=make_output_${__currentTime}.txt
__ctestOutputFilename=ctest_output_${__currentTime}.txt

echo "${__numProc}"
echo "${__makeOutputFilename}"
echo "${__ctestOutputFilename}"

make ${__forceRebuild} -j "${__numProc}" 2>&1 |tee ${__makeOutputFilename} && ctest --verbose 2>&1 |tee ${__ctestOutputFilename} 

