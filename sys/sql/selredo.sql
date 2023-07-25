select group#,
       status,
       substr(member,1,50) member
from v$logfile;

select GROUP#,
       THREAD#,
       SEQUENCE#,
       BYTES,
       MEMBERS,
       ARCHIVED,
       STATUS,
       FIRST_CHANGE#,
       substr(to_char(FIRST_TIME,'DD-MON-YYYY HH24:MI:SS'),1,22) switch_time
from   v$log
order by GROUP#
/
