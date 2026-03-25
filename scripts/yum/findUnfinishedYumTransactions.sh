#!/bin/bash 

find /var/lib/yum -maxdepth 1 -type f -name 'transaction-all*' -not -name '*disabled' -printf . | wc -c