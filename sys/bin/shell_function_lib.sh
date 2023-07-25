#/bin/bash
#
# $Header: /jbs/var/cvs/utils/bin/shell_function_lib.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# Miscellaneous utility functions
#
# Tested under bash
#
# $Log: shell_function_lib.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
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