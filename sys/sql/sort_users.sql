select sid,serial#, srt.username,  sum(blocks*value/(1024*1024)) MB
from v$sort_usage srt, v$session sess, v$parameter
where srt.session_addr=sess.saddr
and name='db_block_size'
group by sid,serial#, srt.username;
