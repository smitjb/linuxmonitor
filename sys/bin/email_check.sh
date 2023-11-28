#!/bin/bash

this_dir=$(dirname ${0})
TIMESTAMP=$(date +%Y%m%d_%H%M%S)


LOGROOT=${this_dir}/../logs
LOGFILE=${LOGROOT}/email_check_${TIMESTAMP}.log

this_dir=$(dirname ${0})
if [ ${this_dir} == "." ];then
        this_dir=$(pwd)
fi


#echo "this_dir:[$this_dir]"
cfg_dir="$this_dir/../etc"

cfg_file=$cfg_dir/monitor_services.ini

REPORT_NEEDED="Y"
echo "Starting at ${TIMESTAMP}" >${LOGFILE}
echo "Finishing at $( date +%Y%m%d_%H%M%S)" >>${LOGFILE}
if [ ${REPORT_NEEDED} == "Y" ];then
#         mail -s "Email check" -r monitor@ponder-stibbons.com -c smitjb0809@gmail.com jim@ponder-stibbons.com <${LOGFILE}
set -x
       bash -x /jbs/sys/bin/smtpsender.sh smitjb0809+monitor@gmail.com  "email check"   "$( cat ${LOGFILE} )"

fi

