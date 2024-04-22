#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)



this_dir=$(dirname ${0})
if [ ${this_dir} == "." ];then
        this_dir=$(pwd)
fi


LOGROOT=${this_dir}/../logs
LOGFILE=${LOGROOT}/monitor_services_${TIMESTAMP}.log

#echo "this_dir:[$this_dir]"
cfg_dir="$this_dir/../etc"

cfg_file=$cfg_dir/monitor_services.ini

REPORT_NEEDED="N"
echo "Starting at ${TIMESTAMP}" >${LOGFILE}
for host in $(cat ${cfg_file} | awk -F: '{ print $1 }')
do
	# 
	# host detection section 
	#
	# use nmap -sn host
	PING_REQUIRED=$(grep ${host} ${cfg_file} | awk -F: '{ print $2 }')
#	echo "PING_REQUIRED:[$PING_REQUIRED]"
	echo -n "$host ->" >>${LOGFILE}
	PINGRESULT=$(nmap -sn  -Pn ${host} |grep "^Host is" | awk '{ print $3 }')

	if [ "${PINGRESULT}" == "up." ];then
		echo "  pingable" >>${LOGFILE}
	else
		if [ ${PING_REQUIRED} == "Y" ];then
			echo "  not pingable" >>${LOGFILE}
			REPORT_NEEDED="Y"
		else
			echo "ping ignored" >>${LOGFILE}
		fi
	fi
	# 
	# port scan section
	# 
	# use nmap -p port host 
	for port in $(grep $host ${cfg_file}| awk -F: '{ print $3 }')
	do
#		nc -z  -4 ${host} ${port} #>/dev/null #2&>1
		PORTRESULT=$(nmap -p ${port} -Pn ${host} | grep "^${port}" |awk '{ print $2 }')
		if [ ${PORTRESULT} == "open" ];then
			echo OK ${host} ${port} open >>${LOGFILE}
		else
			echo FAIL ${host} ${port} not open >>${LOGFILE}
			REPORT_NEEDED="Y"
		fi
	done
done
if [ ${REPORT_NEEDED} == "Y" ];then
	cat ${LOGFILE}
#	/jbs/sys/bin/smtpsender.sh smitjb0809+monitor@gmail.com  "Warning services missing"   "$( cat ${LOGFILE} )"
         #mail -s "Warning services missing" -r monitor@aquila-eth jim@ponder-stibbons.com <${LOGFILE}

fi

echo "Finishing at $( date +%Y%m%d_%H%M%S)" >>${LOGFILE}
