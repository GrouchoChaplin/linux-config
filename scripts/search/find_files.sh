# list your candidate roots here
#dirs=(dir1 dir2 dir3/subdir1)
dirs=(/run/media/peddycoartte/MasterBackup/PreCleanup.2025_03_13_T14_37_49/peddycoartte/Development/Projects /run/media/peddycoartte/MasterBackup/KernalPanic.2025_04_07_T09_19_09/peddycoartte/Development/Projects /run/media/peddycoartte/MasterBackup/PreCleanup./peddycoartte/Development/Projects /run/media/peddycoartte/MasterBackup/peddycoartte/Development/Projects/ /run/media/peddycoartte/MasterBackup/peddycoartte/Development/Projects/)

# the exact filename you’re hunting
fname="volumetric_cloud_shader.glsl"   # <-- change me

find "${dirs[@]}" -type f -name "$fname" -printf '%T@ %p\n' \
| sort -nr \
| head -n "$N" \
| awk '{t=$1; $1=""; sub(/^ /,""); cmd="date -d @"int(t) " +\"%F %T\""; cmd | getline ts; close(cmd); print ts "  " $0}'

