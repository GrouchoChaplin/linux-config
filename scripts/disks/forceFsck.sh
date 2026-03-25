################################################################################
#                                                                              #
#!/bin/bash                                                                    #
#                                                                              #
################################################################################
################################################################################
#                                                                              #
#  script: forceFsck.sh 
#                                                                              #
#  Description:                                                                #
#                                                                              #
#                                                                              #
################################################################################

#	By creating /forcefsck file you will force the Linux system (or rc scripts) 
#	to perform a full file system check. First, login as the root user:

sudo su
cd /
touch /forcefsck
reboot