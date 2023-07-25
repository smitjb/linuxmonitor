#
# $Header: /jbs/var/cvs/orascripts/bin/topandtail.sh,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
#
# 
# $Log: topandtail.sh,v $
# Revision 1.1.1.1  2012/12/28 17:34:15  jim
# First import
#
# Revision 1.2  2012/05/22 08:31:03  jim
# Fixed typo in procedure header edit
#
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.1.1.1  2005/11/27 10:10:20  jim
# Migrated from client sight
#
#
#
# =======================================================================

if [ "${1}" = "" ]
then
 usage
fi
FILE=$(echo ${1}|sed 's/\r//')
if [ ! -f ${FILE} ];then
 echo ${FILE} does not exist.
 exit 1
fi
cp ${FILE} ${FILE}.bak
sed -e 's/^package body */create or replace package body /i' \
    -e 's/^package */create or replace package /'i \
    -e 's/^procedure   */create or replace procedure /'i \
    -e 's/^function   */create or replace function /'i \
    -e 's/^trigger   */create or replace trigger /'i \
    -e 's/^view   */create or replace view /'i \
    <${FILE} >${FILE}.tmp
#echo create or replace >${FILE}.tmp
#cat ${FILE} >>${FILE}.tmp
echo / >> ${FILE}.tmp
rm ${FILE}
mv ${FILE}.tmp ${FILE}

usage() {
  echo topandtail: add pl/sql header and footer to files
  echo usage - "topandtail <filename>"
}
