#/bin/ksh
#
# pias_sppurge.ksh
#
# Wrapper for pias_sppurge.sql to housekeep statspack snapshots
#
# Parameters
#
#  1    number of days of snapshots to retain (default 30)
#
# =============================================================

. ~/.profile

DEFAULT_DAYS_TO_RETAIN=30
SQLDIR=~/sql

DAYS_TO_RETAIN=${1}
if [ -z "${DAYS_TO_RETAIN}" ];then
 DAYS_TO_RETAIN=${DEFAULT_DAYS_TO_RETAIN}
fi

sqlplus perfstat/perfstat @${SQLDIR}/pias_sppurge.sql ${DAYS_TO_RETAIN}

