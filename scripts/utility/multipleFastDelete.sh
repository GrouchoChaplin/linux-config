#!/bin/env bash 

fastDelete()
{
	__dirToEmpty="${1}"
	printf "Emptying %s\n" ${__dirToEmpty}
	EMPTYDIR=$(mktemp -d)
	rsync -r --delete $EMPTYDIR/ "${__dirToEmpty}"/
	# ls -ls "${__dirToEmpty}"
	rm -rfv "${__dirToEmpty}"
}

for dir in "$@"
do
    fastDelete "${dir}"
done
