#/bin/bash
#
# $Header: /jbs/var/cvs/utils/bin/repdemo_shell_functions.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# Miscellaneous utility functions
#
# Tested under bash
#
# $Log: repdemo_shell_functions.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.4  2007/03/04 10:29:47  jim
# Fixed typo in assigning parameter to SITE_LIST
#
# Revision 1.3  2007/03/04 10:08:42  jim
# Fixes in response to testing
# More automation
#
# Revision 1.2  2007/02/27 16:37:41  jim
# New read config file function
#
# Revision 1.1  2007/02/24 11:01:19  jim
# New utility functions
#
#
#
# =====================================================================

function echo_debug(){
#
# Prints messages to stderr if the DEBUG environment variable is set to
# TRUE
#
#
 if [ "${DEBUG}" == "TRUE" ]
 then
  echo $* >&2
 fi
}

function find_file_in_path(){
#
# find a file in a path by prepending each element of a path
# to the supplied filename
# 
# Parameters
# 1 the file name
# 2 the path
#
# Prints the first absolute path to the filemon stdout
# Use FULLPATH=$( find_file_in_path test.txt $PATH ) or
# FULLPATH=`find_file_in_path test.txt $PATH `
FILENAME=${1}
SEARCHPATH=${2}

for path in $( echo ${SEARCHPATH} | sed 's/:/ /g')
do
 echo_debug ${path} ${FILENAME} 
 if [ -f ${path}/${FILENAME} ]
 then
     echo ${path}/${FILENAME}
     exit
 fi
done
echo "${FILENAME} not found" >&2
echo ${FILENAME}

}

function read_config() {
#
# Set the required environment variables from 
# the supplied configuration file.
#
# The format of the configuration file is such that
# th variables can be set by sourcing the config file
# i.e.
# . config_file

if [ "${1}" == "" ]
then
  CONFIGFILE=repdemo.conf
else
  CONFIGFILE=${1}
fi

if [ ! -f ${CONFIGFILE} ]
then
 FQFILENAME=$(find_file_in_path ${CONFIGFILE} ".:..:../bin:../etc")
else
 FQFILENAME=${CONFIGFILE}
fi

. ${FQFILENAME}

}

function validate_connectivity() {
if [ "${1}" == "" ]
then
    SITE_LIST="${REPDEMO_MASTER_DEF_SITE} ${REPDEMO_SITES}"
else
    SITE_LIST=${1}
fi
echo "Validating sites  at $(date)" 
echo "Site list is [${SITE_LIST}]"  
#
# Is TNSNAMES set up and is the database accessible from here?
#
FAILED=""
for sitename in ${SITE_LIST}
do
 echo Testing network setup for ${sitename} #| tee -a ${LOGFILE}
 #echo tnsping x${sitename}x
 tnsping ${sitename} #>>$LOGFILE
 if [ ! "$?" == "0" ]
 then
   echo '*Failed' #| tee -a ${LOGFILE}
   FAILED="${FAILED} ${sitename}"
 else
   echo OK #| tee -a ${LOGFILE}
 fi
done
if [ ! "${FAILED}" == "" ]
then
  echo "The script failed to connect to one of more sites. Aborting" #| tee -a ${LOGFILE}
  echo "Failed sites:[${FAILED}]" #| tee -a ${LOGFILE}
  echo "See ${LOGFILE} for details"
  exit 1
fi

}