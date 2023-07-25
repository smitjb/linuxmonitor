#
# $Header: /jbs/var/cvs/utils/bin/cvschanges.sh,v 1.1.1.1 2012/05/22 07:32:58 jim Exp $
# 
# Lists files in a directory tree which under CVS control and have
# been modified
#
#
# $Log: cvschanges.sh,v $
# Revision 1.1.1.1  2012/05/22 07:32:58  jim
# general purpose utilities
#
# Revision 1.1.1.1  2005/11/27 10:10:20  jim
# Migrated from client sight
#
#
# ===================================================================

cvs status |grep File:| grep -v Up-to-date
