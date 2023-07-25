column sessid format a15
column username format a15
column osuser   format a20
column status format a10
column logon_time format a18 
col machine format a25 newline
column terminal format a25 
column program  format a25 
column module  format a25
column action  format a25 
break on sessid skip 1
select ''''||sid||','|| serial#||'''' sessid, 
       username,
       osuser,
       status,
       logon_time,
       machine, 
       terminal,
       program,
       module,
       action
from v$session
where type <> 'BACKGROUND'
/
