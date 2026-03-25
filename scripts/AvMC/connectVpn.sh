#!/bin/env bash 

printf "\33[2J";

#sudo openconnect --servercert pin-sha256:LvAKeeRD8GpB92XYaIVIsr8Tk7GuqErGyXliGA3+ufE= -c "pkcs11:token=PEDDYCOART.THOMAS.E.1395809136;id=%00%01" --verbose https://vpn.amrdec.army.mil 
sudo openconnect --servercert pin-sha256:TTd7viM758dy2GwwPAbGipeHNZADmKxKdIhkQu0b/kE= -c "pkcs11:token=PEDDYCOART.THOMAS.E.1395809136;id=%01"    --verbose https://vpn.amrdec.army.mil



