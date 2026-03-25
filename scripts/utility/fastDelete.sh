#!/bin/env bash 

__dirToEmpty="${1}"
printf "Emptying %s\n" ${__dirToEmpty}
EMPTYDIR=$(mktemp -d)
rsync -r --delete $EMPTYDIR/ "${__dirToEmpty}"/
ls -ls "${__dirToEmpty}"
rm -rfv "${__dirToEmpty}"


# __dirToEmpty="${1}"
# printf "Emptying %s\n" ${__dirToEmpty}
# EMPTYDIR=$(mktemp -d);  rsync -r --delete $EMPTYDIR/ $1; ls -ls "${__dirToEmpty}" ;rm -rfv "${__dirToEmpty}"
