#!/bin/bash
#
# $Header: /jbs/var/cvs/utils/bin/backup_all_ora_db.sh,v 1.1 2012/05/22 07:55:13 jim Exp $
#
#
# Script to backup a set of database using rman. It processes a list of 
# databases and passes the work on to backup_ora_db.sh
#
#
#
# Parameters
#
# 1 - name of file containing list of databases to backup
#
# 2 - backup location. 
#     optional. If omitted, uses default value specified in script
#
# @TODO move defaults to a configuration file
# @TODO provide support for scheduling information in configuration file
# @TODO add getopt for more flexible options.
#
# $Log: backup_all_ora_db.sh,v $
# Revision 1.1  2012/05/22 07:55:13  jim
# First checkin after import
#
# Revision 1.1  2006/09/04 15:54:26  jim
# First tested version
#
#
#
# =====================================================
#
# Options
# Currently hardcoded but should be available as command line options
# or from configuration file
# -----------------------------
DELETE_OBSOLETE="TRUE" # run delete obsolete after backup
SET_OPTIONS="FALSE"    # change some configuration options for this session onlySET_OPTIONS_FILE="/dev/null" # file used if SET_OPTIONS is TRUE
BACKUP_LOCATION="/jbs/var/backup/db/oracle"
BACKUP_FORMAT="%U"

# basic environment
. /jbs/sys/etc/cron.profile

SCRIPTPATH=$(dirname $0)
NLS_DATE_FORMAT='DD-Mon-YYYY HH24:MI:SS'
export NLS_DATE_FORMAT
RMAN=cat
RMAN=rman
if [ "${1}" != "" ]
then
 SIDFILE=${1}
else 
 SIDFILE=$(dirname ${SCRIPTPATH})/etc/BACKUP_SIDS
fi

if [ "${2}" != "" ]
then
 BACKUP_LOCATION=${2}
fi
set
echo ORASID=$ORASID
echo LOCATION=$BACKUP_LOCATION

#
#

SIDLIST=$(grep -v '^#' $SIDFILE)
echo $SIDLIST

for dbsid in ${SIDLIST}
do
 echo "Backing up ${dbsid}"
 ${SCRIPTPATH}/backup_ora_db.sh ${dbsid}
 if (( $? != 0 )) 
 then
     echo "Error backing up ${dbsid}"
 else
     echo "Backup complete"
 fi
done
