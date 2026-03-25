#!/bin/bash

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
mtbuild()
{
	__numProc=$(nproc)
	__numMakeProc=__numProc
	((__numMakeProc--))
	make -j  "${__numMakeProc}"
}