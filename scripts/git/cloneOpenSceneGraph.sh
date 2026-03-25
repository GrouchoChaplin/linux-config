#!/bin/env bash 

__OSGTarget="${1:-OpenSceneGraph}"

#echo "Clone OpenSceneGraph to: " "${__JSIGTarget}"
git clone ssh://git@bitbucket.di2e.net:7999/jsig/openscenegraph.git "${__OSGTarget}"

