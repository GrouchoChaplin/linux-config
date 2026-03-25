#!/bin/env bash 

git remote set-branches --add origin $1 && git fetch origin $1:$1
