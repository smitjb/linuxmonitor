#/bin/bash
#
set -x
BACKUP_TYPE=${1}
BACKUP_TARGET="${2}"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

BACKUP_ROOT=/shares//backup2
BACKUP_DIR=${BACKUP_ROOT}/${BACKUP_TYPE}

FLAGFILE=${BACKUP_ROOT}/${BACKUP_TYPE}/backup_${TIMESTAMP}.log
LOGROOT=/home/root/logs
LOGFILE=${LOGROOT}/${BACKUP_TYPE}_backup_${TIMESTAMP}.log

case $BACKUP_TARGET in
	*data*) DATA_EXCLUDE=""
             ;;
         *)     DATA_EXCLUDE="--exclude=data"
             ;;
esac

date >>${LOGFILE}
if [  -d ${BACKUP_DIR} ];then
	echo  "cd "${BACKUP_TARGET}"; find . |cpio -pdmv ${BACKUP_DIR}" >>${LOGFILE} 
	touch ${FLAGFILE}
	cd "${BACKUP_TARGET}" ; find . |cpio -pdmv ${BACKUP_DIR} >>${LOGFILE} 2>&1
	touch ${FLAGFILE}
else
	echo "${BACKUP_DIR} not mounted" >>${LOGFILE}

fi
date >>${LOGFILE}

