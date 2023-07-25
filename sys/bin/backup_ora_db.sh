#!/bin/bash
#
# $Header: /jbs/var/cvs/utils/bin/backup_ora_db.sh,v 1.1 2012/05/22 07:55:13 jim Exp $
#
# $Name:  $
#
# Script to backup a database using rman.
#
##
# Parameters
#
# 1 - database name (SID or SERVICE)
#     optional. If omitted uses current default database (ORACLE_SID or LOCAL)
#
# 2 - backup location. 
#     optional. If omitted, uses default value specified in script
#
# @TODO move defaults to a configuration file
# @TODO provide support for rman catalog
# @TODO add getopt for more flexible options.
#
# $Log: backup_ora_db.sh,v $
# Revision 1.1  2012/05/22 07:55:13  jim
# First checkin after import
#
# Revision 1.2  2006/09/23 14:31:52  jim
# Moved backup to db specific subdirectory
# Added compression option
#
# Revision 1.1.1.1  2006/09/03 18:34:02  jim
# First checkin
#
#
# =====================================================
#
# Options
# Currently hardcoded but should be available as command line options
# or from configuration file
# -----------------------------
DELETE_OBSOLETE="TRUE" # run delete obsolete after backup
COMPRESS_OPTION="as compressed backupset"
SET_OPTIONS="FALSE"    # change some configuration options for this session onlySET_OPTIONS_FILE="/dev/null" # file used if SET_OPTIONS is TRUE

BACKUP_LOCATION="/jbs/var/backup/db/oracle"
BACKUP_FORMAT="%d/%n_%T_DB_%t_%p_%c"

RMAN=cat
RMAN=rman
if [ "${1}" != "" ]
then
 ORASID=${1}
else 
 ORASID=${ORACLE_SID}
fi

if [ "${2}" != "" ]
then
 BACKUP_LOCATION=${2}
fi

if [ "${DELETE_OBSOLETE}" == "TRUE" ]
then
 DEL_OBSOLETE_COMMAND="delete noprompt obsolete;"
fi
echo ORASID=$ORASID
echo LOCATION=$BACKUP_LOCATION
echo DEL_OBSOLETE_CMD=${DEL_OBSOLETE_COMMAND}

#
# Set the appropriate environment
#
ORACLE_SID=${ORASID}
ORAENV_ASK=NO
. oraenv
unset ORAENV_ASK

${RMAN} <<EOF
connect target;
show all;
backup ${COMPRESS_OPTION} database format '${BACKUP_LOCATION}/${BACKUP_FORMAT}' ;
${DEL_OBSOLETE_COMMAND}
EOF
