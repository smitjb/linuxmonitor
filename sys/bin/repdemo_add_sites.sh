#
# $Header: /jbs/var/cvs/utils/bin/repdemo_add_sites.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# Copyright (c) Ponder Stibbons Limited 2007
# 
# This software may be freely distributed providing the original copyright is acknowledged.
#
#
# $Log: repdemo_add_sites.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
#
#=======================================================================================
ALLARGS="$*"

. repdemo_shell_functions.sh

read_config
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
BIN_DIR=.
SQL_DIR=../sql

 if [ ! "${NEWSITE}" == "" ]
 then
   # we are adding a single site
   SITE_LIST=${NEWSITE}
 else
   # we are linking a bunch of existing sites
   SITE_LIST="${REPDEMO_SITES}"
 fi

LOGFILE=repdemo_create_db_links.log
echo "Creating database links at $(date)"
if [ ! "${NEWSITE}" == "" ]
then
 echo "New site is ${NEWSITE}"
else 
 echo "Site list is ${SITE_LIST}"  
fi

if [ ! "${NOVALIDATE}" == "TRUE" ]
then
validate_connectivity

  if [ ! "$?" == "0" ]
  then
   echo "The script failed to connect to one or more sites. Aborting" 
   exit
  fi
fi


for THIS_SITE in ${SITE_LIST}
do
 echo "Adding site ${THIS_SITE}"
 ${BIN_DIR}/repdemo_run_script_all.sh --novalidate --masterdefonly --username=${USERNAME}  --password=${PASSWORD} --script=${SQL_DIR}/repdemo_add_site.sql ${THIS_SITE}
  
done
