#!/bin/bash

currentDateTime=$(date "+%Y_%m_%d_T%H_%M_%S")

rsync --progress --human-readable --perms --archive --verbose --recursive --links --log-file=/home/peddycoartte/.logs/Backups/mainbackup.${currentDateTime}.output.txt /home/peddycoartte /run/media/peddycoartte/MasterBackup/Daily/.

