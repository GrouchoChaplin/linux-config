#!/bin/bash

#pringSepLine 80
printf "Setting Environment: %s\n" "$(date)"
#pringSepLine 80


################################################################################
#	SET ENVIRONMENT VARIABLES
################################################################################

export HISTTIMEFORMAT="%m/%d/%y %T "


export PATH=/opt/sublime_text_3:"${PATH}"


export FFPLAY_ROOT=/z/Software/ffplay
export FFPLAY_LIB=/z/Software/ffplay/lib
export FFPLAY_BIN=/z/Software/ffplay
export PATH="${FFPLAY_BIN}":"${PATH}"
export LD_LIBRARY_PATH="${FFPLAY_LIB}":"${LD_LIBRARY_PATH}"

#-------------------------------------------------------------------------------
#	Environment Variables For My Scripts  
#-------------------------------------------------------------------------------


export PATH="${SCRIPTS}":"${PATH}"
export PATH="${SCRIPTS}"/main:"${PATH}"
export PATH="${SCRIPTS}"/execution:"${PATH}"
export PATH="${SCRIPTS}"/backup:"${PATH}"
export PATH="${SCRIPTS}"/sysadmin:"${PATH}"
export PATH="${SCRIPTS}"/debugging:"${PATH}"
export PATH="${SCRIPTS}"/disks:"${PATH}"
export PATH="${SCRIPTS}"/git:"${PATH}"


#-------------------------------------------------------------------------------
#	TEAM CITY Environment Variables
#-------------------------------------------------------------------------------
export TEAMCITY_SERVER=ss-teamcity6-lnx.ds.amrdec.army.mil
export TEAMCITY_SERVER_IP_ETH0=10.0.62.177
export TEAMCITY_SERVER_IP_ETH7=192.168.254.30
export TEAMCITY_SERVER_IP="${TEAMCITY_SERVER_IP_ETH0}"


################################################################################
#	3rdParty Tools Environment Variables
################################################################################


#-------------------------------------------------------------------------------
# 	MODTRAN Env Vars
#-------------------------------------------------------------------------------
# export MODTRAN_ROOT=/z/SceneGen_Software/MODTRAN/MODTRAN6.0
export MODTRAN_ROOT="${HOME}"/Development/JSIGModtranTool/MODTRAN/MODTRAN6
export MODTRAN_DATA="${MODTRAN_ROOT}"/DATA
export MODTRAN_BIN="${MODTRAN_ROOT}"/bin/linux
export MODTRAN_INC="${MODTRAN_ROOT}"/developer/include
export MODTRAN_LIB="${MODTRAN_ROOT}"/bin/linux
export PATH="${MODTRAN_BIN}":"${PATH}"
export LD_LIBRARY_PATH="${MODTRAN_LIB}":"${LD_LIBRARY_PATH}"

export MOD6_DIR="${MODTRAN_ROOT}"

#-------------------------------------------------------------------------------
#	PYEQ2 - Used in ZunZun (Curve fitting tool use in Scatter Profile Tools)
#-------------------------------------------------------------------------------
export PYEQ2_ROOT=/home/peddycoartte/Development/AvSTIL.LATEST/Code/ScatterProfileTools/ZunZun/pyeq2


#-------------------------------------------------------------------------------
#	CUDA
#-------------------------------------------------------------------------------
# export CUDA_PATH=/opt/CUDA/cuda-7.0
#export CUDA_PATH=/opt/CUDA/cuda-8.0
export CUDA_PATH=/opt/CUDA/cuda-11.1
export CUDA_BIN=$CUDA_PATH/bin
export CUDA_LIB=$CUDA_PATH/lib64


#-------------------------------------------------------------------------------
#	Data Environment Variables
#-------------------------------------------------------------------------------
export DATA_ROOT=/archive/DATA


#-------------------------------------------------------------------------------
#	JSIG Data Environment Variables
#-------------------------------------------------------------------------------
# export JSIG_DATA="${DATA_ROOT}"/JSIG_Data


#-------------------------------------------------------------------------------
#	(A)PNTSRC Environment Variables
#-------------------------------------------------------------------------------
export APNTSRC_DATA="${DATA_ROOT}"/APNTSRC_DATA


#-------------------------------------------------------------------------------
#	SignaturesFramework/EMSIG/HSIG Environment Variables
#-------------------------------------------------------------------------------
export SIGFW_ROOT=/archive/3rdParty/SignaturesFramework
export SIGFW_BIN="${SIGFW_ROOT}"/bin
export SIGFW_INC="${SIGFW_ROOT}"/include
export SIGFW_LIB="${SIGFW_ROOT}"/lib
export SIGFW_DATA_ROOT="${SIGFW_ROOT}"/data
export SIGFW_MODELS="${SIGFW_DATA_ROOT}"/SignatureModels
export SIGFW_THREATCONFIGS="${SIGFW_DATA_ROOT}"/ThreatConfigurations
export THREATCONFIGS="${DATA_ROOT}"/ThreatConfigurations


################################################################################
#	PATH Modifications
################################################################################

#-------------------------------------------------------------------------------
#	My Scripts
#-------------------------------------------------------------------------------
export PATH="${SCRIPTS}"/RTSG:"${SCRIPTS}"/JSIG:"${PATH}":"${SCRIPTS}"/yum:"${PATH}"

#-------------------------------------------------------------------------------
#	SmartGit
#-------------------------------------------------------------------------------
export PATH=~/bin/smartgit/bin:"${PATH}"

#-------------------------------------------------------------------------------
#	Qt
#-------------------------------------------------------------------------------
export PATH="${HOME}"/Development/Tools/qtcreator-3.6.1/bin:"${PATH}"
# export PATH="${HOME}"/Development/Tools/qtcreator-4.9.1/bin:"${PATH}"





#-------------------------------------------------------------------------------
#	CUDA 
#-------------------------------------------------------------------------------
export LD_LIBRARY_PATH=$CUDA_LIB:$LD_LIBRARY_PATH



#-------------------------------------------------------------------------------
#	TEXLIVE
#-------------------------------------------------------------------------------
export MANPATH=/usr/local/texlive/2019/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2019/texmf-dist/doc/info:$INFOPATH
export PATH=/usr/local/texlive/2019/bin/x86_64-linux:$PATH






if [[ 1 -eq 0 ]]; then 

export MYREPOS="${HOME}"/Development/AEgisBitBucketRepos/epeddycoart


################################################################################
#	Backup Env Vars
################################################################################
export BACKUP_ROOT=/z/z4/peddycoartte/Backups
export AVSTIL_BACKUP_ROOT="${BACKUP_ROOT}"/AvSTIL
export AVSTIL_CODE_BACKUP="${AVSTIL_BACKUP_ROOT}"/Code
export AVSTIL_REPOS_BACKUP="${AVSTIL_BACKUP_ROOT}"/Repos
export DAILY_BACKUP="${BACKUP_ROOT}"/Daily


################################################################################
#	Repository Environment Variables
################################################################################
export AEGIS_GITHUB_ROOT="${HOME}"/Development/AEgisGitHubRepos


################################################################################
#	Development Environment Variables
################################################################################
export DEV_ROOT="${HOME}"/Development
export SOURCE_ROOT="${DEV_ROOT}"/Source
export PROJECTS_ROOT="${SOURCE_ROOT}"/Projects
export AVSTIL_PROJECTS_ROOT="${PROJECTS_ROOT}"/AvSTIL
fi 


