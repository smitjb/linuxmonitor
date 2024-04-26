#!/bin/bash

this_dir=$(dirname ${0})
PARAM=${1}

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
if [ -z "${PARAM}" ] ; then
	address_file=${cfg_dir}/email_check.ini
else 
	address_file=${cfg_dir}/${PARAM}
fi


if [ -f ${address_file} ];then
	MAIL_ADDRESSES=$(cat $address_file)
else
	MAIL_ADDRESSES="jim@ponder-stibbons.co.uk jim@ponder-stibbons.com smitjb0809+monitor@gmail.com random@ponder-stibbons.com chrys@ponder-stibbons.com"

fi

REPORT_NEEDED="Y"
echo "Starting at ${TIMESTAMP}" >${LOGFILE}
if [ ${REPORT_NEEDED} == "Y" ];then
#         mail -s "Email check" -r monitor@ponder-stibbons.com -c smitjb0809@gmail.com jim@ponder-stibbons.com <${LOGFILE}
       for mailaddress in ${MAIL_ADDRESSES}
      	 do
       		echo ${mailaddress}
       		bash  /jbs/sys/bin/smtpsender.sh ${mailaddress}  "email check ${TIMESTAMP}"   "$( cat ${LOGFILE} )"
	done

fi

echo "Finishing at $( date +%Y%m%d_%H%M%S)" >>${LOGFILE}
