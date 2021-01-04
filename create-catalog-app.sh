ndex f1238e3..eee6f32 100755
#!/bin/bash

# To run this set and ecport NIRMATA_TOKEN and if needed NIRMATA_URL before running the script
# Arguments for the script should be catalog, app-name, and yaml file.
CATALOG="$1"
APP="$2"
YAML="$3"


#NIRMATA_TOKEN = 'MY_NIRMATA_TOKEN'
#NIRMATA_URL='https://nirmata.io'
NCTL_URL='https://nirmata-downloads.s3.us-east-2.amazonaws.com/nctl/nctl_3.1.0-rc2/nctl_3.1.0-rc2_linux_64-bit.zip'


if command -v nctl ;then
  nctl catalog app create $APP -c $CATALOG -f $YAML
else
  if [ -f nctl ];then
    chmod +x nctl
  else
    wget -O nctl.zip ${NCTL_URL}
    unzip -o nctl.zip
    chmod 500 nctl
  fi
  ./nctl catalog app create $APP -c $CATALOG -f $YAML
fi
