#
# $Header: /jbs/var/cvs/cvstools/bin/export_source.sh,v 1.1 2013/01/04 10:23:54 jim Exp $
#
# Export an arbitrary set of cvs modules to arbitrary destinations
#
# The set of modules and their destinations is defined in the 
# source_exports.dat file in the format
# modulename:destination directory.
#
# The module is exported as a subdirectory of the destination
#
# ToDo:
#
# The tag to use for exporting is currently semi-hard-coded to 
# FINAL_<todaysdate>. Allow an override.
#
# $Log: export_source.sh,v $
# Revision 1.1  2013/01/04 10:23:54  jim
# Migrated from utils
#
# Revision 1.1  2012/05/22 07:55:14  jim
# First checkin after import
#
# Revision 1.1.1.1  2005/11/27 10:10:20  jim
# Migrated from client sight
#
#
# ==========================================================================
TAG=FINAL_$(date +"%Y%m%d")
WORKDIR=$(pwd)
for MODULE in $(cat ${WORKDIR}/source_exports.dat | egrep -v "^#" | awk -F: '{ print $1 }')
do
 TARGET=$(cat ${WORKDIR}/source_exports.dat | egrep  ${MODULE}: | awk -F: '{ print $2 }')
 echo exporting ${MODULE} to ${TARGET}
 cd "${TARGET}"
 rm -rf ${MODULE}
 cvs -d h:/cvs -N export -r ${TAG} ${MODULE}

done 