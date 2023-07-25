select THREAD#,
       SEQUENCE#,
       FIRST_CHANGE#,
       substr(to_char(FIRST_TIME,'DD-MON-YYYY HH24:MI:SS'),1,22) switch_time,
       SWITCH_CHANGE#
from   v$loghist
order by sequence#
/
