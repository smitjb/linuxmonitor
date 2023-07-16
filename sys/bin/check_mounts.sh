#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
this_dir=$(dirname ${0})
if [ ${this_dir} == "." ];then
        this_dir=$(pwd)
fi


LOGROOT=${this_dir}/../logs
LOGFILE=${LOGROOT}/check_mounts_${TIMESTAMP}.log
MOUNTLIST=/jbs/sys/etc/mountlist

#MOUNTS="/shares/data /shares/backup /shares/backup2 /shares/datum /shares/backup3"
MOUNTS=$( cat ${MOUNTLIST})

echo "${TIMESTAMP}" >${LOGFILE}
REPORT_NEEDED="N"
for mnt in ${MOUNTS}
do
	mounted=$(df |egrep " ${mnt}\$")
#	echo $?
	if [ -z "$mounted" ];then
		echo "${mnt} not mounted" >>${LOGFILE} 
		REPORT_NEEDED="Y"
	fi
done

echo "${TIMESTAMP}" >>${LOGFILE}
if [ ${REPORT_NEEDED} == "Y" ];then
         mail -s "Warning mounts missing" -r monitor@aquila-eth jim@ponder-stibbons.com <${LOGFILE}

        cat ${LOGFILE}
fi

