#!/bin/bash

# Script creates an app in an environment.
# To run this set and ecport NIRMATA_TOKEN and if needed NIRMATA_URL before running the script
# The scripts arguments should be an environment, an app-name and a single yaml file
TARGET_ENV="$1"
APP="$2"
YAML="$3"

#NIRMATA_TOKEN = 'MY_NIRMATA_TOKEN'
#NIRMATA_URL='https://nirmata.io'
NCTL_URL='https://nirmata-downloads.s3.us-east-2.amazonaws.com/nctl/nctl_3.1.0-rc2/nctl_3.1.0-rc2_linux_64-bit.zip'


if command -v nctl ;then
  nctl env app run -e $APP $TARGET_ENV -f $YAML
else
  if [ -f nctl ];then
    chmod +x nctl
  else
    wget -O nctl.zip ${NCTL_URL}
    unzip -o nctl.zip
    chmod 500 nctl
  fi
  ./nctl env app run $APP -e $TARGET_ENV -f $YAML
fi
