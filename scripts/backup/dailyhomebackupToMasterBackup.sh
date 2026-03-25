#!/bin/bash

currentDateTime=$(date "+%Y_%m_%d_T%H_%M_%S")
#rsync --dry-run --progress --human-readable --perms --archive --verbose --recursive --links --log-file=/home/peddycoartte/.logs/Backups/mainbackup.${currentDateTime}.output.txt /home/peddycoartte /run/media/peddycoartte/MasterBackup/Emergency.2025_02_06/.


 rsync -azvp /home/peddycoartte /run/media/peddycoartte/MasterBackup/Emergency.2025_02_06_T10_12_40/.

 