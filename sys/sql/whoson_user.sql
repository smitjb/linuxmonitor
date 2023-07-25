column sessid format a15
column username format a30
column osuser   format a30
column program  format a30
column machine format a25
column logon_time format a8
select sid||'-'|| serial# sessid, 
       username,
       osuser,
       program,
       machine,
       TO_CHAR(logon_time,'HH24:MI:SS') LOGON_TIME
from v$session
where type <> 'BACKGROUND'
order by username
/
