#
#
#
#
# Adhoc export script
#
# Variables
#
# USERID       connect string (user/pw[@service)]
# EXPFILE      name of export file
# FULL_OR_USER export mode
#              either "full=Y" or "owner=(ownerlist)"
#              where ownerlist is a comma separated list of schemas.
# LOGFILE      name of log file
# 
#
# ==================================================================
 exp userid=${USERID} \
     file=${EXPFILE} \
     ${FULL_OR_USER} \
     log=${LOGFILE} \
     compress=no \
     grants=y \
     
  
     