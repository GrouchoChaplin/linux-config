#!/bin/bash

##pringSepLine 80
printf "Setting Environment: %s\n" "$(date)"
##pringSepLine 80


################################################################################
#	SET ENVIRONMENT VARIABLES
################################################################################

#	Backup related env vars
export LOG_FILES="${HOME}"/.logs
export BASH_LOGS="${LOG_FILES}"/BASH
export BACKUP_LOGS="${LOG_FILES}"/Backups
export COMPLETE_BACKUP_LOGS="${LOG_FILES}"/Backups/Complete
export DAILY_BACKUP_LOGS="${LOG_FILES}"/Backups/Daily
export SYSTEM_BACKUP_LOGS="${LOG_FILES}"/Backups/System


export MY_AVMC_MACHINE="ss-jsig2-lnx.ds.amrdec.army.mil"
export HISTTIMEFORMAT="%m/%d/%y %T "


#-------------------------------------------------------------------------------
#	Environment Variables For My Scripts  
#-------------------------------------------------------------------------------

export PATH="${SCRIPTS}":"${PATH}"
export PATH="${SCRIPTS}"/main:"${PATH}"
export PATH="${SCRIPTS}"/AvMC:"${PATH}"
export PATH="${SCRIPTS}"/execution:"${PATH}"
export PATH="${SCRIPTS}"/backup:"${PATH}"
export PATH="${SCRIPTS}"/sysadmin:"${PATH}"
export PATH="${SCRIPTS}"/debugging:"${PATH}"
export PATH="${SCRIPTS}"/disks:"${PATH}"
export PATH="${SCRIPTS}"/git:"${PATH}"
export PATH="${SCRIPTS}"/development:"${PATH}"
export PATH="${SCRIPTS}"/utility:$PATH
export PATH="${SCRIPTS}"/web:$PATH


#-------------------------------------------------------------------------------
#	PYEQ2 - Used in ZunZun (Curve fitting tool use in Scatter Profile Tools)
#-------------------------------------------------------------------------------
#export PYEQ2_ROOT=/home/peddycoartte/Development/AvSTIL.LATEST/Code/ScatterProfileTools/ZunZun/pyeq2


#-------------------------------------------------------------------------------
#	CUDA
#-------------------------------------------------------------------------------
export CUDA_PATH="/usr/local/cuda-12.1"
export CUDA_BIN="${CUDA_PATH}/bin"
export CUDA_LIB="${CUDA_PATH}/lib64"
export PATH="${CUDA_BIN}":"${PATH}"
export LD_LIBRARY_PATH="${CUDA_LIB}":"${LD_LIBRARY_PATH}"

# Driver:   Not Selected
# Toolkit:  Installed in /usr/local/cuda-12.1/

# Please make sure that
#  -   PATH includes 
#  -   LD_LIBRARY_PATH includes /usr/local/cuda-12.1/lib64, or, add /usr/local/cuda-12.1/lib64 to /etc/ld.so.conf and run ldconfig as root

# To uninstall the CUDA Toolkit, run cuda-uninstaller in /usr/local/cuda-12.1/bin
# ***WARNING: Incomplete installation! This installation did not install the CUDA Driver. A driver of version at least 530.00 is required for CUDA 12.1 functionality to work.
# To install the driver using this installer, run the following command, replacing <CudaInstaller> with the name of this run file:
#     sudo <CudaInstaller>.run --silent --driver


################################################################################
#	PATH Modifications
################################################################################

#-------------------------------------------------------------------------------
#	My Scripts
#-------------------------------------------------------------------------------
export PATH="${SCRIPTS}"/RTSG:"${SCRIPTS}"/JSIG:"${PATH}":"${SCRIPTS}"/yum:"${PATH}"


#-------------------------------------------------------------------------------
#	TEXLIVE
#-------------------------------------------------------------------------------
export MANPATH=/usr/local/texlive/2019/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2019/texmf-dist/doc/info:$INFOPATH
export PATH=/usr/local/texlive/2019/bin/x86_64-linux:$PATH


################################################################################
#	Vulkan
################################################################################
# Copyright (c) 2015-2019 LunarG, Inc.
# source this file into an existing shell.

export VULKAN_SDK=/opt/vulkan/1.2.182.0/x86_64
export PATH=$VULKAN_SDK/bin:$PATH
export LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH
export VK_LAYER_PATH=$VULKAN_SDK/etc/vulkan/explicit_layer.d


export PATH=${HOME}/bin/chrome-linux:${PATH};
export PATH=${HOME}/Software/TaskWarrior/bin:${PATH};
