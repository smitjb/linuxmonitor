#
# $Header: /jbs/var/cvs/utils/bin/repdemo_build_all.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# $Log: repdemo_build_all.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
#
#
#
# ====================================================================

. repdemo_shell_functions.sh

read_config



#
# Stage 1 - Create the users (repadmin and repdemo)
#
./repdemo_build_stage_1.sh

#
# Stage 2 -  Create the master definition site
# Create the master definition site and
# the replication group and add the objects
# 
# 
./repdemo_build_stage_2.sh

#
# Stage 3 - Create the other master sites.
#
#repdemo_build_stage_3.sh

#
# Stage 4 - Enable replication
# 
#repdemo_build_stage_4.sh

