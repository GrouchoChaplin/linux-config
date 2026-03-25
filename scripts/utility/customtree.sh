#!/bin/env bash 

tree ${1} | sed 's/\xc2\xa0/ /g'