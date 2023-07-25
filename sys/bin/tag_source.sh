#
# $Header: /jbs/var/cvs/utils/bin/tag_source.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
# 
# Apply a common tag to an arbitrary set of cvs modules
#
# The set of modules and their destinations is defined in the 
# source_exports.dat file in the format
# modulename:destination directory.
#
# ToDo:
#
# The tag to use is currently semi-hard-coded to FINAL_<todaysdate>. 
# Allow an override.
#
# $Log: tag_source.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.1.1.1  2005/11/27 10:10:20  jim
# Migrated from client sight
#
# ==========================================================================
TAG=FINAL_$(date +"%Y%m%d")
WORKDIR=$(pwd)

echo Tagging source with ${TAG}

SOURCE_ROOT=/cygdrive/c/work/dev/

for MODULE in $(cat ${WORKDIR}/source_exports.dat | egrep -v "^#" | awk -F: '{ print $1 }')
do

  echo Tagging module ${MODULE}

  cd ${SOURCE_ROOT}${MODULE} 
  pwd
  cvs -N tag -f -R ${TAG}

done