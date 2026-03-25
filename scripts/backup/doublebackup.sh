#!/bin/env bash

NOW=$(date "+%Y_%m_%d_T%H_%M_%S")

rsync -aHAXv --delete --log-file=/home/peddycoartte/MasterBackup/NightlyBackup.${NOW}.txt /home/peddycoartte  /run/media/peddycoartte/MasterBackup/Nightly/.
rsync -aHAXv --delete --log-file=/home/peddycoartte/MasterBackup/DevelopmentFolderBackup.${NOW}.txt  /home/peddycoartte/Development  /run/media/peddycoartte/MasterBackup/DevelopmentBackups/. 


