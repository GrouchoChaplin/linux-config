#!/usr/bin/env bash

MYTOPDIR="MyTopDir"

find "$MYTOPDIR" -type d -name "MySub*Dir" \
  -exec find {} -type d -name "MySubSub*Dir" \
    -exec find {} -type f -name "MyFile*.ext*" \
      -printf '%T@\t%TY-%Tm-%TdT%TH:%TM:%TS\t%p\0' \; \; \
| sort -z -n -r -k1,1 \
| awk -v RS='\0' -F '\t' '
  {
    # $1 = epoch timestamp
    # $2 = YYYY-MM-DDTHH:MM:SS
    # $3 = /path (which may include spaces)
    
    cmd = sprintf("sha256sum \"%s\"", $3)
    cmd | getline sumline
    close(cmd)
    # sumline => "<sha256>  /full/path"
    
    split(sumline, arr, "  ")
    sha256 = arr[1]
    print $2, sha256, $3
  }
'







find "$MYTOPDIR" -type d -name "MySub*Dir" \
  -exec find {} -type d -name "MySubSub*Dir" \
    -exec find {} -type f -name "MyFile*.ext*" \
      -printf '%T@\t%TY-%Tm-%TdT%TH:%TM:%TS\t%p\0' \; \; 
