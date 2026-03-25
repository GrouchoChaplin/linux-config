#!/bin/bash 

git for-each-ref --sort=committerdate refs/heads refs/remotes --format='%(committerdate:short) %(refname:short)'
