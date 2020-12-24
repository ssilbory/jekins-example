#!/bin/bash

# Script updates the an app running in an environment.
# To run this set and ecport NIRMATA_TOKEN and if needed NIRMATA_URL before running the script
# The scripts arguments should be a catalog, an app-name, and a single yaml file


#NIRMATA_TOKEN = 'MY_NIRMATA_TOKEN'
#NIRMATA_URL='https://nirmata.io'
NCTL_URL='https://nirmata-downloads.s3.us-east-2.amazonaws.com/nctl/nctl_3.1.0-rc2/nctl_3.1.0-rc2_linux_64-bit.zip'


if command -v nctl ;then
  nctl catalog apps apply $2 -c $1 -f $3
else
  if [ -f nctl ];then
    chmod +x nctl
  else
    wget -O nctl.zip ${NCTL_URL}
    unzip -o nctl.zip
    chmod 500 nctl
  fi
  ./nctl catalog apps apply $2 -c $1 -f $3
fi
