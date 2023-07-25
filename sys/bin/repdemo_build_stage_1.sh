#
# $Header: /jbs/var/cvs/utils/bin/repdemo_build_stage_1.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# Stage 1 of the build - set up the master definition site
#
# Create the repadmin user on all sites
# Create the repdemo user on all sites
# Create the non-replication objects on all sites
# Create the replication objects on master def site only.
#
# $Log: repdemo_build_stage_1.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.1  2007/03/01 14:01:45  jim
# Unit tested script for first part of replication setup
#
#
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
 LASTSTAGE=4
fi
echo "============================================================================================"
echo "Running substages 1.${STARTSTAGE}-1.${LASTSTAGE}"
echo "============================================================================================"
validate_connectivity

if [ ! "$?" == "0" ]
then
 echo "Could not connect to all sites, aborting"
 exit 1
fi

BIN_DIR=.
DDL_DIR=../ddl
#
# Create the repadmin user at all sites.
#
STAGE="1.1 - Create repadmin user"
if [ $STARTSTAGE -le 1 ]
then
echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"
${BIN_DIR}/repdemo_run_script_all.sh --novalidate --username=${REPDEMO_DBA_USER}  --password=${REPDEMO_DBA_PASSWORD} --script=${DDL_DIR}/repdemo_repadmin_user.sql ${REPDEMO_REPADMIN_USER} ${REPDEMO_REPADMIN_PASSWORD}

if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi
#
# Create the repdemo user at all sites
#
STAGE="1.2 - Create repdemo user"
if [ $STARTSTAGE -le 2 -a $LASTSTAGE -ge 2 ]
then

echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"
${BIN_DIR}/repdemo_run_script_all.sh --novalidate --masterdefonly --username=${REPDEMO_DBA_USER} --password=${REPDEMO_DBA_PASSWORD} --script=${DDL_DIR}/repdemo_user.sql ${REPDEMO_REPDEMO_USER} ${REPDEMO_REPDEMO_PASSWORD} ${REPDEMO_TABLESPACE}
if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

#
# create the non-replication objects at all sites
# spefically sequences.
#
STAGE="1.3 - Create non-replication objects"
if [ $STARTSTAGE -le 3 -a $LASTSTAGE -ge 3 ]
then

echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"
${BIN_DIR}/repdemo_run_script_all.sh --novalidate --masterdefonly --username=${REPDEMO_REPDEMO_USER} --password=${REPDEMO_REPDEMO_PASSWORD} --script=${DDL_DIR}/repdemo_schema_non_rep.sql

#
# create the replication objects at the master definition site only
#
if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

STAGE="1.4 - Create replication objects"
if [ $STARTSTAGE -le 4 -a $LASTSTAGE -ge 4 ]
then

echo "============================================================================================"
 echo "Running ${STAGE}"
echo "============================================================================================"
${BIN_DIR}/repdemo_run_script_all.sh --masterdefonly --novalidate --username=${REPDEMO_REPDEMO_USER} --password=${REPDEMO_REPDEMO_PASSWORD} --script=${DDL_DIR}/repdemo_schema_rep.sql 

if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi
