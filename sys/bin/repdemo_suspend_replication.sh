#
# $Header: /jbs/var/cvs/utils/bin/repdemo_suspend_replication.sh,v 1.1 2012/05/22 07:55:15 jim Exp $
#
# $Log: repdemo_suspend_replication.sh,v $
# Revision 1.1  2012/05/22 07:55:15  jim
# First checkin after import
#
# Revision 1.2  2007/03/04 10:30:26  jim
# Added validation of group name and check for current status
#
# Revision 1.1  2007/03/04 10:08:43  jim
# Fixes in response to testing
# More automation
#
#
#===============================================================================

. repdemo_shell_functions.sh

read_config

LOGFILE=repdemo_suspend_replication.log
echo "Suspending replication at $(date)" | tee ${LOGFILE}
echo "Master site is ${REPDEMO_MASTER_DEF_SITE}."  | tee -a ${LOGFILE}

validate_connectivity ${REPDEMO_MASTER_DEF_SITE}
if [ ! "${?}" == "0" ]
then
 echo "Connectivity check failed"
 exit 1
fi

sqlplus -s ${REPDEMO_REPADMIN_USER}/${REPDEMO_REPADMIN_PASSWORD}@${REPDEMO_MASTER_DEF_SITE} <<EOF
set serveroutput on
declare
 repgroup varchar2(30);
 status varchar2(30); 
 begin
   begin
    select gname, status
    into repgroup, status
    from dba_repgroup
    where gname=upper('${REPDEMO_REPGROUP}');
   exception
    when no_data_found then
      repgroup:='INVALID';
    when others then 
      raise;
   end;
 if repgroup = 'INVALID' THEN
   DBMS_OUTPUT.PUT_LINE('No such group ['||'${REPDEMO_REPGROUP}'||']');
 else if status = 'QUIESCED' then
   DBMS_OUTPUT.PUT_LINE('Group ['||'${REPDEMO_REPGROUP}'||'] is already suspended');
    else 
     DBMS_REPCAT.suspend_master_activity('${REPDEMO_REPGROUP}');
    end if;
  end if;
 end;
/
exit
EOF

