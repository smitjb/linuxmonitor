 select a.username us, a.osuser os, a.sid, a.serial#
 from v$session a, v$locked_object b, dba_objects c
 where upper(c.object_name) = upper('&&1')
 and b.object_id = c.object_id
 and a.sid  = b.session_id;
