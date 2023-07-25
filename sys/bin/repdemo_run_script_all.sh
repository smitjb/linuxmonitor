#
# $Header: /jbs/var/cvs/utils/bin/repdemo_run_script_all.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
# 
# This scipt runs a nominated sqlscript against all databases in sitelist.txt
#
# Parameters
# 1 username/password
# 2 script 
# 3... parameters for sql script.
#
# Tested on bash under cygwin and rhel4.
#
# ToDo
# 
# Allow force option for inaccessible databases
# Better command line handling
#
# $Log: repdemo_run_script_all.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.2  2007/03/01 11:08:29  jim
# Added getopt commandline parameter handling
# Moved some functionality to function library
#
# Revision 1.1  2007/02/23 17:24:05  jim
# First versions
#
# ====================================================================

ALLARGS="$*"

. repdemo_shell_functions.sh

read_config

OPTARGS=$(getopt -o mnvupes: --long masterdefonly,nomasterdef,novalidate,username:,password:,script:,environment: \
               -n 'repdemo_run_script_all.sh'\
               -- ${ALLARGS})

eval set -- "${OPTARGS}"
while true ; do
        case "$1" in
                -m|--masterdefonly) #echo "Masterdef only"  
                                    MASTERDEFONLY=TRUE 
		                     shift ;;
                -n|--nomasterdef) #echo "noMasterdef "  
                                    NOMASTERDEF=TRUE 
		                     shift ;;
                -v|--novalidate) #echo "Novalidate" 
		                     NOVALIDATE=TRUE
                                      shift ;;
                -e|--environment)
                                #echo "Environment $2"
                                eval $2
                                #echo X=$X
                                shift 2 ;;
                --) shift ; break ;;
                -u|--username)
                                #echo "username $2"
				USERNAME="${2}"
                                shift 2 ;;
                -p|--password)
                                #echo "password $2"
                                PASSWORD="${2}"
                                shift 2 ;;
                -s|--script)
                                #echo "script $2"
                                SCRIPT="${2}"
                                shift 2 ;;

                *) echo "Internal error!" ; exit 1 ;;
        esac
done

if [ "$SCRIPT" == "" ]
then 
  SCRIPT=$1
  shift
fi
SCRIPT_DIR=$(dirname ${0})
if [ "${SCRIPT_DIR}" == "." ]
then
 SCRIPT_DIR=$(pwd)
fi
LOG_DIR=$(dirname ${SCRIPT_DIR})/logs
SQL_DIR=$(dirname ${SCRIPT_DIR})/sql

#
# validate script
#
# Is there a script parameter?
if [ "${SCRIPT}" == "" ]
then
 echo "No script name supplied" 
 exit 1
else
 SCRIPTFILE=$(find_file_in_path ${SCRIPT} ".:../sql:../ddl")
fi
if [ "${SCRIPTFILE}" == "" ]
then
  echo "Unable to find script file ${SCRIPT}"
  exit 1
fi
LOGFILE=${LOG_DIR}/${SCRIPT}.log


if [ "${NOVALIDATE}" == "" ]
then
  validate_connectivity
  if [ "$?" == "0" ]
  then
   echo "Error validating connectivity"
   exit 1
  fi
fi

if [ ! "${MASTERDEFONLY}" == "" ]
then
 SITE_LIST=${REPDEMO_MASTER_DEF_SITE}
else if [ "${NOMASTERDEF}" == "TRUE" ]
     then
       SITE_LIST="${REPDEMO_SITES}"        
     else
       SITE_LIST="${REPDEMO_MASTER_DEF_SITE} ${REPDEMO_SITES}"
     fi
fi 



echo "Running script against [ $SITE_LIST ]"

for THIS_SITE in ${SITE_LIST}
do
 echo "Running script against ${THIS_SITE}" # | tee -a ${LOGFILE}
    sqlplus ${USERNAME}/${PASSWORD}@${THIS_SITE} @${SCRIPTFILE} $* 
done


