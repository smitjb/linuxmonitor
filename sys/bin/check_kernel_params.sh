#!/bin/bash
# 
# $Header: /jbs/var/cvs/utils/bin/check_kernel_params.sh,v 1.1 2012/05/22 07:55:13 jim Exp $
#
# Extract kernel and module information for oracle 
# prerequisite checks
#
# $Log: check_kernel_params.sh,v $
# Revision 1.1  2012/05/22 07:55:13  jim
# First checkin after import
#
# Revision 1.1  2006/09/04 19:02:17  jim
# First checkin
#
#
# 
# =========================================================
echo "********** Kernel Parameters  ************************"
echo Semaphores $(cat /proc/sys/kernel/sem)
echo shmall $(cat /proc/sys/kernel/shmall)
echo shmmax $(cat /proc/sys/kernel/shmmax)
echo shmmni  $(cat /proc/sys/kernel/shmmni)
echo file-max $(cat /proc/sys/fs/file-max )
echo ip_local_port_range $(cat /proc/sys/net/ipv4/ip_local_port_range)
echo rmem_default $(cat /proc/sys/net/core/rmem_default)
echo rmem_max $(cat /proc/sys/net/core/rmem_max)
echo wmem_default $(cat /proc/sys/net/core/wmem_default)
echo wmem_max $(cat /proc/sys/net/core/wmem_max)
echo "**************************************************"

echo "********** Installed RPMS ************************"
rpm -q -a | egrep -f ../etc/rpm_patterns | sort
echo "**************************************************"
