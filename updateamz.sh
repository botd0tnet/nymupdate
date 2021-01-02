#!/bin/bash

## Colours variables for the installation script
RED='\033[1;91m' # WARNINGS
YELLOW='\033[1;93m' # HIGHLIGHTS
WHITE='\033[1;97m' # LARGER FONT
LBLUE='\033[1;96m' # HIGHLIGHTS / NUMBERS ...
LGREEN='\033[1;92m' # SUCCESS
NOCOLOR='\033[0m' # DEFAULT FONT

function systemd_ison () {
if systemctl list-units --state=running | grep nym-mixnode
then echo "stopping nym-mixnode.service to update the node ..." && systemctl stop nym-mixnode
else echo " nym-mixnode.service is inactive or not existing. Downloading new binaries ..."
fi
}
function updatex () {
  #set -x
  if [ ! -d /home/nym/.nym/mixnodes ]
  then
    echo "Looking for nym config in /home/nym but could not find any! Enter the path of the nym-mixnode executable"
    read nym_path
    cd $nym_path


  else
    cd /home/nym
  fi

  if systemctl list-units --state=running | grep nym-mixnode
  then echo "stopping nym-mixnode.service to update the node ..." && systemctl stop nym-mixnode
  else echo " nym-mixnode.service is inactive or not existing..."
  fi

  ip_addr=`curl -sS v4.icanhazip.com`
  ahost=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
  location=(Nuremberg Helsinki CapeTown Usa Dubai Iowa Frankfurt Toronto Netherlands Berlin Bayern London Toulouse Amsterdam Nuremberg Virginia Montreal Miami Stockholm Tokyo Barcelona Singapore China)
  rand=$[$RANDOM % ${#location[@]}]
  location1=${location[$rand]}
  layer=(1 2 3)
  rand1=$[$RANDOM % ${#layer[@]}]
  layer1=${layer[$rand1]}   
  walletx=(1 2 3)
  rand2=$[$RANDOM % ${#walletx[@]}]
  walletx1=${layer[$rand2]}  
  sudo -u nym -H ./nym-mixnode_linux_x86_64 init --id 'NymMixNode' --location $location1 --incentives-address $walletx1 --host $ahost --announce-host $ip_addr  --layer $layer1
}

updatex && echo "ok" && sleep 2 || exit 1
sleep 5 && systemctl start nym-mixnode.service
