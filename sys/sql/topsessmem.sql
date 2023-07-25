select  sess.username, 
        sess.program, 
        s1.sid,
        round(s1.value/1024,0) session_pga_memory ,
        round(s2.value/1024,0) session_pga_memory_max
from v$sesstat s1, 
     v$sesstat s2,
     v$session sess
where s1.sid=s2.sid
and s1.sid=sess.sid
and s1.statistic#=25
and s2.statistic#=26
order by session_pga_memory_max desc, session_pga_memory desc;

