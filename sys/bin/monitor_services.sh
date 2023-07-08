#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)


LOGROOT=/home/root/logs
LOGFILE=${LOGROOT}/monitor_services_${TIMESTAMP}.log

this_dir=$(dirname ${0})

echo "this_dir:[$this_dir]"
cfg_dir="$this_dir/../etc"

cfg_file=$cfg_dir/monitor_services.ini

REPORT_NEEDED="N"

for host in $(cat ${cfg_file} | awk -F: '{ print $1 }')
do
	echo -n "$host ->" >>${LOGFILE}
	ping -c 1 $host >/dev/null
	if [ $? == 0 ];then
		echo "  pingable" >>${LOGFILE}
	else
		echo "  not pingable" >>${LOGFILE}
		REPORT_NEEDED="Y"
	fi
	for port in $(grep $host ${cfg_file}| awk -F: '{ print $2 }')
	do
		nc -z  -4 ${host} ${port} #>/dev/null #2&>1
		if [ $? == 0 ];then
			echo OK ${host} ${port} open >>${LOGFILE}
		else
			echo FAIL ${host} ${port} not open >>${LOGFILE}
			REPORT_NEEDED="Y"
		fi
	done
done
if [ ${REPORT_NEEDED} == "Y" ];then
         mail -s "Warning services missing" -r monitor@aquila-eth jim@ponder-stibbons.com <${LOGFILE}

        cat ${LOGFILE}
fi



