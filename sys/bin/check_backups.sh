#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)



this_dir=$(dirname ${0})
if [ ${this_dir} == "." ];then
	this_dir=$(pwd)
fi	

BACKUP_ROOT=/shares/backup
TYPES="jbsbackups sysbackups homebackups codebackups"

LOGROOT=${this_dir}/../logs
LOGFILE=${LOGROOT}/check_backups_${TIMESTAMP}.log


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
	 mail -s "Warning backups missing" -r monitor@aquila-eth jim@ponder-stibbons.com <${LOGFILE}

	cat ${LOGFILE}
fi

