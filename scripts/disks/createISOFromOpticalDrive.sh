#!/bin/env bash 

#	Get optical drive/device 
__opticalDrive=${1:-"/dev/sr0"}

#	Get iso filename
__isoFilename=${2:-"devsr0file.iso"}


#	Get mount point 
__mountPoint=${3:-"/run/media/peddycoartte/isomount"}

# Get blocksize
__blockSize=$(isosize -d 2048 "${__opticalDrive}")


echo "Optical Drive: " "${__opticalDrive}"
echo "Block Size:    " ${__blockSize}
echo "ISO Filename:  " "${__isoFilename}"
echo "Mount Point:   " "${__mountPoint}"

#	Create CD-ROM/DVD ISO image with dd command:
sudo dd if="${__opticalDrive}" of="${__isoFilename}" bs=2048 count="${__blockSize}" status=progress

 #	Mount to check
 sudo umount "${__mountPoint}"
 sudo mount -o loop "${__isoFilename}" "${__mountPoint}"
 ls -ls "${__mountPoint}"
