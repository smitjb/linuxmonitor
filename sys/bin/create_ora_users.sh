#!/bin/bash
# 
# $Header: /jbs/var/cvs/utils/bin/create_ora_users.sh,v 1.1 2012/05/22 07:55:13 jim Exp $
#
# Create the groups and users required to install oracle
#
#
# Needs to run as root
#
# @TODO make group names and ids configurable (parameter/config file)
# @TODO make user names and ids configurable (parameter/config file)
# 
# $Log: create_ora_users.sh,v $
# Revision 1.1  2012/05/22 07:55:13  jim
# First checkin after import
#
# Revision 1.2  2006/10/13 15:26:34  jim
# Added missing quote at end of message
#
# Revision 1.1  2006/09/04 19:02:17  jim
# First checkin
#
#
# ==========================================================================
if [ "$(id -u)" != 0 ]
then
    echo "This script must be run as root"
    exit 1
fi

if [ ! -d /jbs ]
then
   echo "Standard directory structure not in place."
   echo "Please run create_standard_directories.sh
fi



#
# first create the groups
#
DBAGIDOPT=-g
DBAGID=501
OPERGIDOPT=-g
OPERGID=502
INVGIDOPT=-g
INVGID=503
DBAGROUPNAME=dba
OPERGROUPNAME=oper
INVGROUPNAME=oinstall


echo "Creating dba group as ${DBAGID}(${DBAGROUPNAME})"
groupadd ${DBAGIDOPT} ${DBAGID} ${DBAGROUPNAME}
echo "Creating operator group as ${OPERGID}(${OPERGROUPNAME})"
groupadd ${OPERGIDOPT} ${OPERGID} ${OPERGROUPNAME}
echo "Creating inventory group as ${INVGID}(${INVGROUPNAME})"
groupadd ${INVGIDOPT} ${INVGID} ${INVGROUPNAME}

#
# now create the user
#
DBAUIDOPT=-g
DBAUID=501
echo "Creating oracle user as ${DBAUID}(oracle)"
useradd ${DBAUIDOPT} ${DBAUID} -g ${INVGROUPNAME} -s /bin/bash -d /jbs/opt/oracle -c "Oracle software owner" -G ${DBAGROUPNAME},${OPERGROUPNAME} -n -p oracle oracle

#_EOF
