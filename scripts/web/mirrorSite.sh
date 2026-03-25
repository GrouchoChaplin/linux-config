#!/bin/env bash 

# Mirror a website 
wget --mirror --convert-links --adjust-extension --page-requisites -e robots=off --no-parent $1
