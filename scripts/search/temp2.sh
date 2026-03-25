# list your candidate roots here
#dirs=(dir1 dir2 dir3/subdir1)
#dirs=(/home/peddycoartte/projects/jsig /home/peddycoartte/projects/rfss)

dirs=( "/home/peddycoartte/projects/jsig/jsig"  "/home/peddycoartte/projects/rfss/jsig.1414" "/home/peddycoartte/projects/rfss/jsig")


# the exact filename you’re hunting
fname="dyneticsClouds.cfg"   # <-- change me

find "${dirs[@]}" -type f -name "$fname" -printf '%T@ %p\n' \
| sort -nr \
| head -n 1 \
| awk '{ $1=""; sub(/^ /,""); print }'
