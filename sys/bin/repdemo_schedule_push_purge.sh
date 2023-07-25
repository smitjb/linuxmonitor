#
# $Header: /jbs/var/cvs/utils/bin/repdemo_schedule_push_purge.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
#
# Copyright (c) Ponder Stibbons Limited 2007
# 
# This software may be freely distributed providing the original copyright is acknowledged.
#
## $Log: repdemo_schedule_push_purge.sh,v $
## Revision 1.1  2012/05/22 07:55:15  jim
## First checkin after import
##
# Revision 1.3  2007/02/26 13:15:07  jim
# Fixed check for inaccessible sites
#
# Revision 1.2  2007/02/23 17:39:40  jim
# Re-written to use run_script_all.sh
#
# Revision 1.1  2007/02/23 17:24:05  jim
# First versions
#
#
# ================================================================
ALLARGS="$*"

. repdemo_shell_functions.sh

read_config
SQL_DIR=../sql
OPTARGS=$(getopt -o ns:u:p: --long novalidate,newsite:,username:,password: \
               -n 'repdemo_build_stage_1.sh'\
               -- ${ALLARGS})

eval set -- "${OPTARGS}"
while true ; do
        case "$1" in
                -s|--newsite) NEWSITE="$2"; 
		                     shift 2 ;;
                -n|--novalidate) NOVALIDATE=TRUE
		                   shift  ;;
                -u|--username)
                                #echo "username $2"
				USERNAME="${2}"
                                shift 2 ;;
                -p|--password)
                                #echo "password $2"
                                PASSWORD="${2}"
                                shift 2 ;;
	        --) shift
                   break  ;;
        esac
done

#echo "[$NEWSITE]"
#exit

SITE_LIST="${REPDEMO_MASTER_DEF_SITE} ${REPDEMO_SITES}"


echo "Scheduling push and purge jobs $(date)"
if [ ! "${NEWSITE}" == "" ]
then
 echo "New site is ${NEWSITE}"
fi
echo "Site list is ${SITE_LIST}"  

if [ ! "${NOVALIDATE}" == "TRUE" ]
then
validate_connectivity

  if [ ! "$?" == "0" ]
  then
   echo "The script failed to connect to one or more sites. Aborting" 
   exit
  fi
fi

for THIS_SITE in ${SITE_LIST} ${NEWSITE}
do
 echo "Creating purge job for ${THIS_SITE}"
 sqlplus -s ${USERNAME}/${PASSWORD}@${THIS_SITE} @${SQL_DIR}/repdemo_create_purge.sql
 echo "Creating push from ${THIS_SITE}
 sqlplus -s ${USERNAME}/${PASSWORD}@${THIS_SITE} @${SQL_DIR}/repdemo_create_push.sql ${REPDEMO_REPGROUP}
done

