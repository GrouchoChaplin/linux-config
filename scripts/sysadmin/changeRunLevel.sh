################################################################################
#                                                                              #
#!/bin/bash                                                                    #
#                                                                              #
################################################################################
################################################################################
#                                                                              #
#  script: changeRunLevel.sh 
#                                                                              #
#  Description:                                                                #
#                                                                              #
#                                                                              #
################################################################################


#	https://www.centos.org/forums/viewtopic.php?t=47306

# Runlevel 3 is now multi-user.target and runlevel 5 is now graphical.target.

# systemctl set-default multi-user.target;
# systemctl set-default graphical.target;

# To switch from graphical to multi-user:
# systemctl isolate multi-user.target;

# To switch from multi-user to graphical:
# systemctl isolate graphical.target;


systemctl isolate multi-user.target;
