#
# $Header: /jbs/var/cvs/utils/bin/repdemo_build_stage_3.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
#
# Copyright (c) Ponder Stibbons Limited 2007
# 
# This software may be freely distributed providing the original copyright is acknowledged.
#
## Stage 3 of the build
#
# Create the OTHER master sites.
#
# 1 Create the repadmin user at each site
# 2 Create the repdemo user at each site
# 3 Install the non-replication objects at each site
# 4 Create the database links
# 5 Create the purge and push jobs
# 6 Add the site as a master site at the master definition site.
#
# $Log: repdemo_build_stage_3.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
#
# ====================================================================
#set -x
ALLARGS="$*"

. repdemo_shell_functions.sh

read_config
OPTARGS=$(getopt -o s:l: --long startstage:,laststage: \
               -n 'repdemo_build_stage_1.sh'\
               -- ${ALLARGS})

eval set -- "${OPTARGS}"
while true ; do
        case "$1" in
                -s|--startstage) STARTSTAGE=$2 
		                     shift 2 ;;
                -l|--laststage) LASTSTAGE=$2
		                   shift 2 ;;
	        --) shift
                   break  ;;
        esac
done

if [ "$STARTSTAGE" == "" ]
then
 STARTSTAGE=1
fi

if [ "$LASTSTAGE" == "" ]
then
 LASTSTAGE=6
fi
echo "============================================================================================"
echo "Running substages 3.${STARTSTAGE}-3.${LASTSTAGE}"
echo "============================================================================================"
validate_connectivity

if [ ! "$?" == "0" ]
then
 echo "Could not connect to all sites, aborting"
 exit 1
fi

BIN_DIR=.
DDL_DIR=../ddl
SQL_DIR=../sql

#
# Create the repadmin user at each site
#
STAGE="3.1 - Create repadmin user"
if [ $STARTSTAGE -le 1 ]
then
echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"
${BIN_DIR}/repdemo_run_script_all.sh --novalidate --nomasterdef --username=${REPDEMO_DBA_USER}  --password=${REPDEMO_DBA_PASSWORD} --script=${DDL_DIR}/repdemo_repadmin_user ${REPDEMO_REPADMIN_USER} ${REPDEMO_REPADMIN_PASSWORD} 

if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi
#
# Create the repdemo_user at each site.
#
STAGE="3.2 - Create the repdemo user"
if [ $STARTSTAGE -le 2 -a $LASTSTAGE -ge 2 ]
then

echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"
${BIN_DIR}/repdemo_run_script_all.sh --novalidate --nomasterdef --username=${REPDEMO_DBA_USER} --password=${REPDEMO_DBA_PASSWORD} --script=${DDL_DIR}/repdemo_user.sql ${REPDEMO_REPDEMO_USER} ${REPDEMO_REPDEMO_PASSWORD} ${REPDEMO_TABLESPACE}

if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

#
# create the non repication objects
#
STAGE="3.3 - Create the non-replication objects"
if [ $STARTSTAGE -le 3 -a $LASTSTAGE -ge 3 ]
then

echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"

${BIN_DIR}/repdemo_run_script_all.sh --novalidate --nomasterdef --username=${REPDEMO_REPDEMO_USER} --password=${REPDEMO_REPDEMO_PASSWORD} --script=${DDL_DIR}/repdemo_schema_non_rep.sql


if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

#
# Create datanbase links
#
# Every site needs to have a database link to all other sites.
#
STAGE="3.4 - Create the database links"
if [ $STARTSTAGE -le 4 -a $LASTSTAGE -ge 4 ]
then

echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"

${BIN_DIR}/repdemo_create_db_links.sh --novalidate --username=${REPDEMO_REPADMIN_USER} --password=${REPDEMO_REPADMIN_PASSWORD}  



if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

#
# create the scheduled jobs
# Every site needs 1 purge job
# and a push job for all other sites.
#

STAGE="3.5 - Create the scheduled jobs"
if [ $STARTSTAGE -le 5 -a $LASTSTAGE -ge 5 ]
then

echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"

${BIN_DIR}/repdemo_schedule_push_purge.sh --novalidate --username=${REPDEMO_REPADMIN_USER} --password=${REPDEMO_REPADMIN_PASSWORD} 


if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

#
# Add sites to the master group
#
STAGE="3.6 - Add the site to the master group"
if [ $STARTSTAGE -le 6 -a $LASTSTAGE -ge 6 ]
then

echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"
${BIN_DIR}/repdemo_add_sites.sh --novalidate --username=${REPDEMO_REPADMIN_USER}  --password=${REPDEMO_REPADMIN_PASSWORD} 

if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

