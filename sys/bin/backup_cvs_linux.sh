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
cd /jbs/var
tar cvzf /backup/cvs_${TIMESTAMP}.tgz cvs
cd /backup
find . -name 'cvs*tgz' -mtime +8 -exec rm {} \;
