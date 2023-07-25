#
# $Header: /jbs/var/cvs/utils/bin/repdemo_create_db_links.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# Copyright (c) Ponder Stibbons Limited 2007
# 
# This software may be freely distributed providing the original copyright is acknowledged.
#
#
# $Log: repdemo_create_db_links.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.3  2007/03/04 10:47:18  jim
# REmoved various hardcoded entries
# Moved some stuff to repdemo_shell_functions.sh
#
# Revision 1.2  2007/02/26 13:15:29  jim
# Fixed check for inaccessible sites
#
# Revision 1.1  2007/02/23 17:24:05  jim
# First versions
#
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

#echo "[$NEWSITE]"
#exit

SITE_LIST="${REPDEMO_MASTER_DEF_SITE} ${REPDEMO_SITES}"
LOGFILE=repdemo_create_db_links.log
echo "Creating database links at $(date)"
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
 echo "Creating db_links for ${THIS_SITE}" 
 if [ ! "${NEWSITE}" == "" ]
 then
   # we are adding a single site
   INNER_SITE_LIST=${NEWSITE}
 else
   # we are linking a bunch of existing sites
   INNER_SITE_LIST=${SITE_LIST}
 fi
 for THAT_SITE in ${INNER_SITE_LIST}
 do
   if [ ! "${THIS_SITE}" == "${THAT_SITE}" ]
   then
    # create the link from THIS to THAT
    echo "Creating link from ${THIS_SITE} to ${THAT_SITE}"
    sqlplus -s ${USERNAME}/${PASSWORD}@${THIS_SITE} <<EOF
create database link ${THAT_SITE}
connect to ${REPDEMO_REPADMIN_USER} identified by ${REPDEMO_REPADMIN_PASSWORD}
using '${THAT_SITE}'; 
exit
EOF

   fi
 done
done
