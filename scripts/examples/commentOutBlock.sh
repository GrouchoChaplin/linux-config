#!/bin/bash


# trick for commenting out a block of code
if [ 1 -eq 0 ]; then
	echo "You should not see this"
else 
	echo "You should see this"
fi
