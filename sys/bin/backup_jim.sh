#/bin/bash
#
#
#
# ==============================================
BACKUPDIR=/backup

MOUNTPOINT=$(df /backup| grep -v Filesystem | awk '{ print $NF }')

if [ ${MOUNTPOINT} = "/" ];then
	echo "Backup dir [$BACKUPDIR} not mounted, aborting"
	exit 1
fi

TIMESTAMP=$(date "+%Y%m%d%H%M%S" )
cd /home
tar cvzf /backup/jim_${TIMESTAMP}.tgz jim
cd /backup
find . -name 'jim*tgz' -mtime +8 -exec rm {} \;
