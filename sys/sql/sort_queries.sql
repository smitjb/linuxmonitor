break on report 
compute sum of blocks on report 
select sid,serial#, extents, blocks,user, srt.username,program, machine, sql_text
from v$sort_usage srt, v$session sess, v$sql sql
where srt.session_addr=sess.saddr
and srt.sqladdr=sql.address;
