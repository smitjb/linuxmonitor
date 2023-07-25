#
# $Header: /jbs/var/cvs/utils/bin/repdemo_drop_masterdef_site.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# $Log: repdemo_drop_masterdef_site.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.1  2007/03/04 10:08:42  jim
# Fixes in response to testing
# More automation
#
#
# ============================================================#
REPADMIN_USER=repadmin
REPADMIN_PASSWORD=repadmin
DBA_USER=SYStem
DBA_PASSWORD=planta1n
MASTER_DEF_SITE=olint10
MASTER_REPGROUP=repdemo
# At definition site
#  remove master database(s)
#  drop master_repgroup
#
#
sqlplus ${REPADMIN_USER}/${REPADMIN_PASSWORD}@${MASTER_DEF_SITE} @repdemo_drop_master_databases ${MASTER_REPGROUP}
sqlplus ${REPADMIN_USER}/${REPADMIN_PASSWORD}@${MASTER_DEF_SITE} @repdemo_drop_rep_objects ${MASTER_REPGROUP}
sqlplus ${REPADMIN_USER}/${REPADMIN_PASSWORD}@${MASTER_DEF_SITE} @repdemo_drop_master_repgroup ${MASTER_REPGROUP}
