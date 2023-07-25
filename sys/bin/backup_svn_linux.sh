#/bin/bash
#
#
#
# ==============================================

TIMESTAMP=$(date "+%Y%m%d%H%M%S" )
svnadmin dump /var/svn/ponder | gzip >/backup/svn_${TIMESTAMP}.gz
cd /backup
find . -name 'svn*gz' -mtime +8 -exec rm {} \;
