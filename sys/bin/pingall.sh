#!/bin/bash
#set -x

ipcomponent=0

STARTIP=192.168.1.
echo "The following addresses were pingable addresses" >pingableaddresses.txt
while  [ $ipcomponent != 256 ] 
do
 fullip=${STARTIP}${ipcomponent}
 echo -n Pinging ${fullip} ...
 ping -n 1 ${fullip} >/dev/null 2>&1
 if  [ $? -ne 0 ]
 then
  echo  failed
 else
  echo .
  echo  ${fullip} >>pingableaddresses.txt
 fi
 let ipcomponent=${ipcomponent}+1
 sleep 2
done