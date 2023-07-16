#/bin/bash
#

this_dir=$(dirname ${0})
if [ ${this_dir} == "." ];then
        this_dir=$(pwd)
fi

BACKUP_TYPE=${1}
BACKUP_TARGET="${2}"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

BACKUP_ROOT=/shares//backup2
BACKUP_DIR=${BACKUP_ROOT}/${BACKUP_TYPE}

FLAGFILE=${BACKUP_ROOT}/${BACKUP_TYPE}/backup_${TIMESTAMP}.log

LOGROOT=${this_dir}/../logs
LOGFILE=${LOGROOT}/${BACKUP_TYPE}_backup_${TIMESTAMP}.log

case $BACKUP_TARGET in
	*data*) DATA_EXCLUDE=""
             ;;
         *)     DATA_EXCLUDE="--exclude=data"
             ;;
esac

date >>${LOGFILE}
ERR_MSG=""
if [ ! -d ${BACKUP_ROOT} ];then
        ERR_MSG="Backup volume not mounted"
fi
if [ ! -d ${BACKUP_ROOT}/${BACKUP_TYPE} ];then
        ERR_MSG="Backup directory absent"
fi
if [ ! -z "${ERR_MSG}" ];then
         echo "${ERR_MSG} - ${BACKUP_ROOT}/${BACKUP_TYPE}" >>${LOGFILE}
        echo ${ERR_MSG} |
        mail -s "${ERR_MSG} - ${BACKUP_ROOT}/${BACKUP_TYPE}" \
                -r backups@aqulia-eth \
                jim@ponder-stibbons.com
        exit 1
fi


if [  -d ${BACKUP_DIR} ];then
	echo  "cd "${BACKUP_TARGET}"; find . |cpio -pdmv ${BACKUP_DIR}" >>${LOGFILE} 
	touch ${FLAGFILE}
	cd "${BACKUP_TARGET}" ; find . |cpio -pdmv ${BACKUP_DIR} >>${LOGFILE} 2>&1
	touch ${FLAGFILE}
else
	echo "${BACKUP_DIR} not mounted" >>${LOGFILE}

fi
date >>${LOGFILE}
exit 0
