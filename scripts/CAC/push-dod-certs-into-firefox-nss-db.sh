#!/bin/env bash 

# Example for default Firefox profile:
PROFILE=$(find ~/.mozilla/firefox -name "*.default-release" | head -n1)

for crt in /etc/pki/ca-trust/source/anchors/*.crt; do
    certutil -A -n "$(basename $crt)" -t "C,," -i "$crt" -d sql:"$PROFILE"
done