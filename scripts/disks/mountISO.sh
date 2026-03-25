#!/bin/bash

isoName=$1
sudo mount -o loop $isoName /home/peddycoartte/MOUNTISO
ls -ls /home/peddycoartte/MOUNTISO
