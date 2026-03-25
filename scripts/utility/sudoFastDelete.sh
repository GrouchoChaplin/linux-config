#!/bin/env bash 

__dirToEmpty="${1}"
printf "Emptying %s\n""${__dirToEmpty}"
EMPTYDIR=$(mktemp -d)
sudo rsync -r --delete $EMPTYDIR/ "${__dirToEmpty}"/


