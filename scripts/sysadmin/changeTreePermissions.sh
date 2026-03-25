#!/bin/bash


__userName=$(id -u -n)
__groupName=$(id -g -n)
__whatToChange=$1

echo "USER:  ""${__userName}"
echo "GROUP: ""${__groupName}"

# sudo find "${__whatToChange}" ! -user "${__userName}" -type d -print0 |xargs -0 sudo chown -v "${__userName}":"${__groupName}" 
# sudo find "${__whatToChange}" ! -user "${__userName}" -type f -print0 |xargs -0 sudo chown -v "${__userName}":"${__groupName}"

sudo find "${__whatToChange}" ! -user "${__userName}" -type d -print0 -exec sudo chown -v "${__userName}":"${__groupName}" {} +
sudo find "${__whatToChange}" ! -user "${__userName}" -type f -print0 -exec sudo chown -v "${__userName}":"${__groupName}" {} +
