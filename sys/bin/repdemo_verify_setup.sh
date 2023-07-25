#
# $Header: /jbs/var/cvs/utils/bin/repdemo_verify_setup.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# $Log: repdemo_verify_setup.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.1  2007/02/23 17:24:05  jim
# First versions
#

SITE_LIST=$(cat sitelist.txt)
LOGFILE=repdemo_verify.log
echo "Verifying setup at $(date)" | tee ${LOGFILE}
echo "Site list is ${SITE_LIST}"  | tee -a ${LOGFILE}
#
# Is TNSNAMES set up and is the database accessible from here?
#
AVAILABLE_SITES=""
for sitename in ${SITE_LIST}
do
 echo Testing network setup for ${sitename} | tee -a ${LOGFILE}
 #echo tnsping x${sitename}x
 tnsping ${sitename} >>$LOGFILE
 if [ ! "$?" == "0" ]
 then
   echo '*Failed' | tee -a ${LOGFILE}
 else
   echo OK | tee -a ${LOGFILE}
   AVAILABLE_SITES="${AVAILABLE_SITES} ${sitename}"
 fi
done

echo "Continuing with ${AVAILABLE_SITES}" | tee -a $LOGFILE
for x in ${AVAILABLE_SITES}
do
 echo "Testing db_links from $x" | tee -a ${LOGFILE}
 for y in ${SITE_LIST}
 do
   if [ ! "$x" == "$y" ]
   then
    sqlplus -s repadmin/repadmin@$x @../sql/repdemo_test_db_link $y | tee -a ${LOGFILE}
   fi
 done
done
