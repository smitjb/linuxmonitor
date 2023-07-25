select r.name, sid, serial#,s.saddr,username,machine, program, round((used_ublk*b.value)/(1024)) kb_used 
from v$transaction,v$rollname r, v$session s , v$parameter b
where xidusn=usn
and s.saddr=ses_addr
and b.name='db_block_size'
order by name;

