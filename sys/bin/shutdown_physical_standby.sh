#!/bin/bash
#
# $Header: /jbs/var/cvs/orascripts/bin/shutdown_physical_standby.sh,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
#
# $Name:  $
#
# Script to shutdown a physical standby database
#
# 
#
##
# Parameters
#
# 1 - database name (SID or SERVICE)
#     optional. If omitted uses current default database (ORACLE_SID or LOCAL)
#
# $Log: shutdown_physical_standby.sh,v $
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
SHUTMODE=normal
CANCEL_COMMAND="alter database recover managed standby database cancel;"

if [ "${1}" == "" ]
then 
 echo "Shutting down default phyiscal standby database"
else
 echo "Shutting down physical standby databaase ${1}"
 ORACLE_SID=${1}
 ORAENV_ASK=NO
. oraenv
 unset ORAENV_ASK
fi
sqlplus <<EOF
connect / as sysdba
${CANCEL_COMMAND}
shutdown ${SHUTMODE}
exit
EOF
