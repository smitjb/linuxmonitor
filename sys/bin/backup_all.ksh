
CFGDIR=$(dirname $0)/../etc
BACKUPLIST=${CFGDIR}/backuplist

for dir in $(cat ${BACKUPLIST})
do
  basic_backup.ksh $dir /cygdrive/l/backups
done

