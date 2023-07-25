#
# $Header: /jbs/var/cvs/utils/bin/repdemo_tear_down.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# $Log: repdemo_tear_down.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.1  2007/03/04 10:08:43  jim
# Fixes in response to testing
# More automation
#
#
# ============================================================#

. repdemo_shell_functions.sh

read_config

#
# 1 Quiesce the system
#
repdemo_suspend_replication.sh 
#
# 2 Remove all other sites
#
# for each site
#  remove purge job
#  remove all push jobs
#  delete database link
#  unregister propagator
#  
repdemo_run_script_all.sh ${REPADMIN_USER}/${REPADMIN_PASSWORD} repdemo_clean_up_site.sql ${REPADMIN_USER}

# At definition site
#  remove master database(s)
#  drop master_repgroup
#
#
repdemo_drop_masterdef_site.sh

# 4 Drop the application user
#
repdemo_run_script_all.sh DBA_USER/DBA_PASSWORD repdemo_drop_user.sql REPdemo

# 5 drop the replication administrator   

repdemo_run_script_all.sh DBA_USER/DBA_PASSWORD repdemo_drop_user.sql ${REPADMIN_USER}
