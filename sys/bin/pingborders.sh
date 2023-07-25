#set -x
#
# $Header
#
# $Log: pingborders.sh,v $
# Revision 1.2  2013/01/07 13:42:23  jim
# Added support for cygwin native ping as opposed to windows ping when using cygwin
#
#
#
# WINDOWS PING ping -n 1 -4 -w 1000 host
# windows exit code
# LINUX PING  ping -c 1 -W 1 -q host
# Linux exit code 0 good, 1 noping 2 others

#set -x


PROGDIR=$(dirname $0)
CFGDIR=${PROGDIR}/../etc
CFGFILE=$CFGDIR/borders.cfg

WINDOWS_PING="ping -n 1 -4 -w 1000 %H"
CYGWIN_PING="ping %H 51 1"
LINUX_PING="ping -c 1 -W 1 -q %H"
DNS_AVAILABLE=YES

function check_dns {
   DNS_SERVER=$( cat $CFGFILE | grep -v \# |grep "^dns:"| awk -F: '{ print $2 }')
   DNS_IP=$( cat $CFGFILE | grep -v \# | grep "^host:"| grep ":${DNS_SERVER}:" | awk -F: '{ print $4 }')
   echo  -n "DNS SERVER=${DNS_SERVER} DNS_IP=${DNS_IP} "
   pingit ${DNS_IP}
       if [ "$?" == "0" ];then
        echo -n "."
    else
        echo -n "${DNS_SERVER} inaccessible using addresses"
        DNS_AVAILABLE=N
    fi

}

function pingit {
#set -x
    HOST=${1}
    IP=$( cat $CFGFILE | grep -v \# | grep "^host:"| grep ":${HOST}:" | awk -F: '{ print $4 }')
    if [ "${OSTYPE}" == "cygwin" ];then
        PING=${WINDOWS_PING}
        PING=${CYGWIN_PING}
    elif [ "${OSTYPE}" == "linux-gnu" ];then
        PING=${LINUX_PING}
    fi
    if [ "${DNS_AVAILABLE}" == "YES" ];then
        NEW_PING=$( echo ${PING} | sed "s/%H/${HOST}/" )    
     #   ${PING} ${HOST}# >/dev/null
       PING_OUTPUT=$(${NEW_PING})
       RETCODE=$?
    else
        NEW_PING=$( echo ${PING} | sed "s/%H/${IP}/" )    
#        ${PING} ${IP} #>/dev/null        
       PING_OUTPUT=$(${NEW_PING} )   
    fi
    if [ "${OSTYPE}" == "cygwin" ];then
        if [  "${RETCODE}" == "1" ];then
            return ${RETCODE}
        fi
        echo ${PING_OUTPUT} | grep "100\.0%" >/dev/null
        if [ "$?" == "0" ];then
            RETCODE=1
        else
            RETCODE=0
        fi
    fi
    return ${RETCODE}
}

check_dns
LIST=$( cat $CFGFILE | grep -v \# |grep "^host:"| sort  | awk -F: '{ print $3 }' )
ERROR=NO
for host in ${LIST}
do
    
    label=$( cat $CFGFILE | grep -v \# | grep "^host:"| grep ":${host}:" | awk -F: '{ print $5 }')
    pingit ${host}
    if [ "$?" == "0" ];then
        echo -n "."
    else
        echo "${label} inaccessible"
        ERROR=YES
        break
    fi
done
if [ "$ERROR" == "NO" ];then
    echo "OK"
else
    echo ""
fi
exit
echo -n .
#ping -n 1 -w 250 linksys >/dev/null
pingit linksys.ponder-stibbons.local 
if [ "$?" == "0" ]
then
  echo -n .
#  ping -n 1 -w 250 zyxel >/dev/null
pingit netgear 
  if [ "$?" == "0" ]
  then
   echo -n .
#   ping -n 1  www.oracle.com >/dev/null
    pingit www.oracle.com 
   if [ "$?" == "0" ] 
   then
    echo "Internet accessible"
   else 
    echo "Internet inaccessible"
   fi
  else
    echo "Netgear inaccessible"
  fi
else
  echo "Linksys inaccessible"
fi 
   
