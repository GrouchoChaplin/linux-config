#!/bin/bash

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
ethDrvInfo  ()
{
	printf "Driver Information\n"
	printf -v cmd "ethtool -i eth%d" "$1"
	echo $cmd
	eval $cmd
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
ethDrvStats  ()
{
	printf "Driver Statistics\n"
	printf -v cmd "ethtool -s eth%d" "$1"
	echo $cmd
	eval $cmd
}

#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
traceNIC ()
{
	printf "Tracing NIC\n"
	printf -v cmd "ethtool -p eth%d %d" "$1" "$2"
	echo $cmd
	eval $cmd
}

#netinfo - shows network information for your system
#-------------------------------------------------------------------------------
#                                                                               
#-------------------------------------------------------------------------------
netinfo ()
{
	echo "--------------- Network Information ---------------"
	/sbin/ifconfig | awk /'inet addr/ {print $2}'
	/sbin/ifconfig | awk /'Bcast/ {print $3}'
	/sbin/ifconfig | awk /'inet addr/ {print $4}'
	/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
#	myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
#	echo "${myip}"
	echo "---------------------------------------------------"
}


#-------------------------------------------------------------
# 
#-------------------------------------------------------------
showAvailableExportsOnNFSServer()
{
	__server="${1}"
	showmount -e "${__server}"
}

