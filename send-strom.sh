set -euxo pipefail

for IP in 192.168.12.{11,12} do

  cp ul-visiology-05.05.2021.md5 /backup/senddir/
  sudo ScanSendService -m:2 -i:$IP
  #check if file still here
  while [ -f /backup/senddir/ul-visiology-05.05.2021.md5 ]
    do echo $(date) File still here...
    sleep 10
  done
  sudo ScanSendService -m:3

done
