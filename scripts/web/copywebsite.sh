#!/bin/env bash 

# Copy a website

https://unix.stackexchange.com/questions/18906/how-to-download-specific-files-from-some-url-path-with-wget

wget -r -l1 --no-parent -A ".deb" http://www.shinken-monitoring.org/pub/debian/

-r recursively
-l1 to a maximum depth of 1
--no-parent ignore links to a higher directory
-A "*.deb" your pattern