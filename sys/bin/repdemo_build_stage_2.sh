#
# $Header: /jbs/var/cvs/utils/bin/repdemo_build_stage_2.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# Stage 1 of the build
#
# 1 Create the replication group
# 2 Add the objects
# 3 Generate replication support
#
# $Log: repdemo_build_stage_2.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.1  2007/03/10 17:50:09  jim
# First version
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
 LASTSTAGE=3
fi
echo "============================================================================================"
echo "Running substages 2.${STARTSTAGE}-2.${LASTSTAGE}"
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
# Create the replication group at the master definition site.
#
STAGE="2.1 - Create repgroup"
if [ $STARTSTAGE -le 1 ]
then
 echo "Running ${STAGE}"
${BIN_DIR}/repdemo_run_script_all.sh --novalidate --masterdefonly --username=${REPDEMO_REPADMIN_USER}  --password=${REPDEMO_REPADMIN_PASSWORD} --script=${SQL_DIR}/repdemo_create_group ${REPDEMO_REPGROUP}

if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi
#
# Add the objects at the master definition site
#
STAGE="2.2 - Add objects"
if [ $STARTSTAGE -le 2 -a $LASTSTAGE -ge 2 ]
then

 echo "Running ${STAGE}"
${BIN_DIR}/repdemo_run_script_all.sh --novalidate --masterdefonly --username=${REPDEMO_REPADMIN_USER}  --password=${REPDEMO_REPADMIN_PASSWORD} --script=${SQL_DIR}/repdemo_add_objects ${REPDEMO_REPDEMO_USER} ${REPDEMO_REPGROUP}
if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

#
# generate replication support for the objects at the master definition site
#
STAGE="2.3 - Generate replication support"
if [ $STARTSTAGE -le 3 -a $LASTSTAGE -ge 3 ]
then

 echo "Running ${STAGE}"
${BIN_DIR}/repdemo_run_script_all.sh --novalidate --masterdefonly --username=${REPDEMO_REPADMIN_USER}  --password=${REPDEMO_REPADMIN_PASSWORD} --script=${SQL_DIR}/repdemo_gen_objects  ${REPDEMO_REPDEMO_USER}

if [ ! "$?" == "0" ]
then
 echo "Error running stage ${STAGE}"
 exit 1
fi
else
 echo "Skipping ${STAGE}"
fi

