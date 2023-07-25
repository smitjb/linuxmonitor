column sessid format a20
column username format a20
column osuser   format a30
column program  format a25
column machine format a25
select sid||'-'|| serial# sessid, 
       status,
       username,
       osuser,
       program,
       machine 
from v$session
where type <> 'BACKGROUND'
and  status='ACTIVE'
/
