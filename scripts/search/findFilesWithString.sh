#!/bin/env bash

CORES=$(nproc)
USE=$((CORES - 4))


#/run/media/peddycoartte/MasterBackup/Nightly/2025-10-01/projects/RFSS/rfss/scripts/run_test_prsm_ir_clouds
#  --root "/run/media/peddycoartte/MasterBackup/Nightly/" \

./simple_find_string_in_file_in_folder.sh \
  --root "/run/media/peddycoartte/MasterBackup/Nightly/2025-10-01" \
  --folder "Scenarios*" \
  --file "*clouds.scn*" \
  --string "*clouds*" \
  --exclude ".cache,build,.git" \
  --parallel   --procs 28


# ./find_files_sorted.sh \
#   --root "/path/to/*" \
#   --folder "*sub*folder*" \
#   --file "*.log" \
#   --string "error.*timeout" \
#   --exclude "build,.git,node_modules" \
#   --parallel --procs 8 \
#   --log /tmp/found_errors.log
