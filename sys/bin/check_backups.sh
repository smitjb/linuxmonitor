#!/bin/bash

function do_process_control {
	if [ ! -f ${CFGDIR}/process_control.ini ];then
		echo "YES"
		return
	fi
	GONOGO=$(grep "^${PROCESS_NAME}" ${CFGDIR}/process_control.ini | awk -F: '{ print $2 }' )
        echo ${GONOGO}



}

TIMESTAMP=$(date +%Y%m%d_%H%M%S)



this_dir=$(dirname ${0})
if [ ${this_dir} == "." ];then
	this_dir=$(pwd)
fi	

BACKUP_ROOT=/shares/backup
CFGDIR=${this_dir}/../etc

TYPES="jbsbackups sysbackups homebackups codebackups james3"

LOGROOT=${this_dir}/../logs
LOGFILE=${LOGROOT}/check_backups_${TIMESTAMP}.log

PROCESS_NAME=CHECK_BACKUPS

GO=$(do_process_control)
if [ "${GO}" = "NO" ];then
	echo "Aborting because of process control (${GO})" >>${LOGFILE}

	exit 
else
	echo "Process control is (${GO})" >>${LOGFILE}
fi



REPORT_NEEDED="N"
cd ${BACKUP_ROOT}
for bkuptype in ${TYPES}
do
	echo "checking ${bkuptype}..." >${LOGFILE}
	pushd ${bkuptype}
	foundfile=$(find . -type f -mtime -1)
	echo "[${foundfile}]"
	if [ -z "${foundfile}" ];then
		echo "${bkuptype} missing" >>${LOGFILE}

		REPORT_NEEDED="Y"
	else 
		echo "${foundfile} found" >>${LOGFILE}
	fi
	popd
done
if [ ${REPORT_NEEDED} == "Y" ];then
       /jbs/sys/bin/smtpsender.sh smitjb0809+monitor@gmail.com  "Warning backups missing"   "$( cat ${LOGFILE} )"

	cat ${LOGFILE}
fi

