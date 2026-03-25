#!/bin/sh

rm -rf ./build

cmake                                      \
    -S .                                   \
    -B build                               \
    -DCMAKE_BUILD_TYPE=Release             \
    -DSUPERBUILD_WITH_LICENSEDPRODUCTS=OFF \
    -DSUPERBUILD_JSIG_GIT_TAG=v5.5.3.1     \
    -DBUILD_WITH_CUDA=OFF                  \
    -DFETCHCONTENT_QUIET=OFF               \
    ;
    
#cd build
#exec chrt --idle 0 cmake --build . -j$(nproc)
