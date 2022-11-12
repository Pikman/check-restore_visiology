#! /bin/bash
set -euxo pipefail

TR_FILES="/opt/visiology/postgres-docker/dump"

if  [[ -n $(find $TR_FILES -type f -name "*$(date +%d'.'%m'.'%Y).dump*") ]]
then
  cd /etc/strom21 #search scan_cfg
  sudo ScanSendService -m:3   #stop STORM-transfer-service if it works

  for IP in 192.168.12.{11,12}
  do
    cp $TR_FILES/*$(date +%d'.'%m'.'%Y)*{md5,dump} /backup/senddir/
    sudo ScanSendService -m:2 -i:$IP #start data transfer
    echo "start transfer"
    #check if file still here
    while [[ -n $(find /backup/senddir/ -type f -name "*$(date +%d'.'%m'.'%Y).dump*") ]]
      do echo $(date) File still here...
      sleep 10
    done
  sudo ScanSendService -m:3 #stop STORM-transfer-service
  done
  find /opt/visiology/postgres-docker/dump -type f -name "*$(date +%d'.'%m'.'%Y).dump*"  -exec rm  {} \;
else
  echo "dump files not found in $TR_FILES"
fi
