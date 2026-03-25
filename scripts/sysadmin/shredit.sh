#!/bin/bash

__filesToShred=$1
echo "${__filesToShred}"

__iterations="${2}"
__iterationsArgs=""

if [[ -n "${__iterations// }" ]]; then
	printf -v __iterationsArgs '%.0s-' {1..2};
	iterationsArgs+="iterations="$1
fi  
echo "${__iterationsArgs}"


printf -v __shredCmd "shred --force --remove --verbose --exact --zero  %s %s " "${__iterationsArgs}" "${__filesToShred}"
printf "%s\n" "${__shredCmd}"
eval "${__shredCmd}"

