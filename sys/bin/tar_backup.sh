#/bin/bash
#

BACKUP_TYPE=${1}
BACKUP_TARGET=${2}
RETENTION=${3}

if [ -z ${RETENTION} ];then
	RETENTION=8
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

BACKUP_ROOT=/shares/backup
BACKUP_FILE=${BACKUP_ROOT}/${BACKUP_TYPE}/${BACKUP_TYPE}_backup_${TIMESTAMP}.tgz
LOGROOT=/home/root/logs
LOGFILE=${LOGROOT}/${BACKUP_TYPE}_backup_${TIMESTAMP}.log

case $BACKUP_TARGET in
	*data*) DATA_EXCLUDE=""
             ;;
         *)     DATA_EXCLUDE="--exclude=data --exclude=data2"
             ;;
esac

SYSEXCLUDES=" --exclude=/lost+found --exclude=${BACKUP_ROOT} ${DATA_EXCLUDE} --exclude=/mnt --exclude=/proc --exclude=/dev --exclude=/sys  --exclude=/shares --exclude=/run --exclude=/home "
HOMEEXCLUDES=""
CODEEXCLUDES=" --exclude=win1032b --exclude=win1032b.y"
JBSEXCLUDES=""
case $BACKUP_TARGET in 
        /) EXCLUDES=$SYSEXCLUDES
           ;;
        *home*) EXCLUDES=$HOMEEXCLUDES
            ;;
         *code*) EXCLUDES=$CODEEXCLUDES
            ;;
         *jbs*) EXCLUDES=$JBSEXCLUDES
            ;;
esac
echo tar cvpzf ${BACKUP_FILE} ${EXCLUDES} ${BACKUP_TARGET} >>${LOGFILE}
tar cvpzf ${BACKUP_FILE} ${EXCLUDES} ${BACKUP_TARGET} >>${LOGFILE}

echo Housekeeping >>${LOGFILE}
set -x
if [ -d  ${BACKUP_ROOT}/${BACKUP_TYPE} ];then 
	cd ${BACKUP_ROOT}/${BACKUP_TYPE}
        echo Before >>${LOGFILE}
	ls -ltr >>${LOGFILE}
        echo "Clearing " $(pwd) >>${LOGFILE}
	find . -name '*backup*.tgz' -mtime +${RETENTION} -exec rm {} \;
	echo After >>${LOGFILE}
	ls -ltr >>${LOGFILE}
fi
