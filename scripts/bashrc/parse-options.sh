#!/bin/bash
#
# Example of how to parse short/long options with 'getopt'
#

OPTS=`getopt -o vhncb:o: --long verbose,dry-run,help,clone,buildtype,osgbuildtype: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

__verbose=false
__help=false
__dryRun=false
__clone=false
__buildType="RELEASE"
__osgBuildType="RELEASE"

while true; do
  case "$1" in
    -v | --verbose ) __verbose=true; shift ;;
    -h | --help ) __help=true; shift ;;
    -n | --dry-run ) __dryRun=true; shift ;;
	-c | --clone) __clone=true; shift ;;
	-b | --buildtype) __buildType="${2}" ; shift; shift ;;
	-o | --osgbuildtype) __osgBuildType="${2^^}" ; shift; ;; # shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

echo "Verbose:        " "${__verbose}"
echo "Help:           " "${__help}"
echo "Dry Run:        " "${__dryRun}"
echo "Clone:          " "${__clone}"
echo "Build Type:     " "${__buildType}"
echo "OSG Build Type: " "${__osgBuildType}"

# #!/bin/bash

# #OPTS=`getopt -o vhns: --long verbose,dry-run,help,stack-size: -n 'parse-options' -- "$@"`
# OPTS=`getopt -o vncr:s:b:o:h --long verbose,dryrun,clone,branch,sourcedir,buildtype,osgbuildtype,help:: -n 'parse-options' -- "$@"`

# if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

# echo "$OPTS"
# eval set -- "$OPTS"

# __verbose=0
# __dryrun=0
# __clone=0
# __branch=""
# __sourcedir=""
# __buildtype=RELEASE
# __osgbuildtype=RELEASE

# while true; do
#   case "$1" in

# 	-v | --verbose ) __verbose=1; shift; shift ;;
# 	-n | --dryrun ) __dryrun=1; shift; shift ;;
# 	-c | --clone ) __clone=0; shift; shift ;;
# 	-r | --branch ) __branch="${2}"; shift; shift ;;
# 	-s | --sourcedir ) sourcedir="${2}"; shift; shift ;;
# 	-b | --buildtype ) __buildtype="${2^^}"; shift; shift ;;
# 	-o | --osgbuildtype ) __osgbuildtype="${2^^}"; shift; shift ;;
#     -n | --dry-run ) __dryrun=1; shift; shift ;;
#     -h | --help ) __help=1; shift ;;
#     -- ) shift; break ;;
#     * ) break ;;
#   esac
# done

# echo "Verbose:       ${__verbose}"
# echo "Dry Run:       ${__dryrun}"
# echo "Clone:         ${__clone}"
# echo "Branch:        ${__branch}"
# echo "Source Dir:    ${__sourcedir}"
# echo "Build Type:    ${__buildtype}"
# echo "OSG Build Type ${__osgbuildtype}"
# echo "Help:          ${__help}"