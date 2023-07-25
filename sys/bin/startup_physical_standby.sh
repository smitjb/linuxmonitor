#!/bin/bash
#
# $Header: /jbs/var/cvs/orascripts/bin/startup_physical_standby.sh,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
#
# $Name:  $
#
# Script to startup a physical standby database
#
# 
#
##
# Parameters
#
# 1 - database name (SID or SERVICE)
#     optional. If omitted uses current default database (ORACLE_SID or LOCAL)
#
# $Log: startup_physical_standby.sh,v $
# Revision 1.1.1.1  2012/12/28 17:34:15  jim
# First import
#
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.1  2006/10/13 15:40:45  jim
# First version of scripts to ensure a physical standby database is started
# and stopped appropriately
# sss: ----------------------------------------------------------------------
#
#
#
# =====================================================
#
# Options
# Currently hardcoded but should be available as command line options
# or from configuration file
# -----------------------------

RECOVER_COMMAND="alter database recover managed standby database disconnect from session;"

if [ "${1}" == "" ]
then 
 echo "Starting up default phyiscal standby database"
else
 echo "Starting up physical standby databaase ${1}"
 ORACLE_SID=${1}
 ORAENV_ASK=NO
. oraenv
 unset ORAENV_ASK
fi
sqlplus <<EOF
connect / as sysdba
startup mount
set heading off
select 'Master DB is' || name || ' and this is '||db_unique_name from v$database; 
${RECOVER_COMMAND}
exit
EOF
