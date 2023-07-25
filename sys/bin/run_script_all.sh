#
# $Header: /jbs/var/cvs/orascripts/bin/run_script_all.sh,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
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
# $Log: run_script_all.sh,v $
# Revision 1.1.1.1  2012/12/28 17:34:15  jim
# First import
#
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
#
# ====================================================================

ALLARGS="$*"

. shell_functions.sh

#read_config

OPTARGS=$(getopt -o u:p:s:l:  \
               -n 'repdemo_run_script_all.sh'\
               -- ${ALLARGS})

eval set -- "${OPTARGS}"
while true ; do
        case "$1" in
                -u)
                                #echo "username $2"
				USERNAME="${2}"
                                shift 2 ;;
                -p)
                                #echo "password $2"
                                PASSWORD="${2}"
                                shift 2 ;;
                -s)
                                #echo "script $2"
                                SCRIPT="${2}"
                                shift 2 ;;

                -l)
                                #echo "script $2"
                                SITE_FILE="${2}"
                                shift 2 ;;

                --) break;;
                *) echo "parameter error!" ; exit 1 ;;
        esac
done

if [ "$SCRIPT" == "" ]
then 
  SCRIPT=$1
  shift
fi

SCRIPT_DIR=$(dirname "${0}")
if [ "${SCRIPT_DIR}" == "." ]
then
 SCRIPT_DIR=$(pwd)
fi
LOG_DIR=$(dirname "${SCRIPT_DIR}")/logs
SQL_DIR=$(dirname "${SCRIPT_DIR}")/sql

#
# validate script
#
# Is there a script parameter?
if [ "${SCRIPT}" == "" ]
then
 echo "No script name supplied" 
 exit 1
else
 SCRIPTFILE=$(find_file_in_path ${SCRIPT} ".:./sql/:../sql:../ddl")
fi
if [ "${SCRIPTFILE}" == "" ]
then
  echo "Unable to find script file ${SCRIPT}"
  exit 1
fi

RUNDATE=$(date +"%Y%m%d%H%M%S")

LOGFILE="${LOG_DIR}/${SCRIPT}_${RUNDATE}.log"



 SITE_LIST=$(cat ${SITE_FILE})



echo "Running script against [ $SITE_LIST ]" | tee "${LOGFILE}"

for THIS_SITE in ${SITE_LIST}
do
 echo "Running script against ${THIS_SITE}" | tee -a "${LOGFILE}"
 sqlplus -s /nolog  <<++++>>"${LOGFILE}"
whenever sqlerror exit 1
connect ${USERNAME}/${PASSWORD}@${THIS_SITE}
@${SCRIPTFILE} $* 
exit
++++
 if [ "$?" != "0" ]
 then
   echo "Connection to ${THIS_SITE} failed" | tee -a "${LOGFILE}"
   
 fi
done


