select r.name                      "Rbseg", 
       p.spid                      "Process", 
       s.username||'('||l.sid||')' "Session" 
from   v$sqlarea  sq, 
       v$lock     l, 
       v$process  p, 
       v$session  s, 
       v$rollname r 
where l.sid                   = p.pid(+) 
and   s.sid                   = l.sid 
and   trunc(l.id1(+) / 65536) = r.usn 
and   l.type(+)               = 'TX' 
and   l.lmode(+)              = 6 
and   s.sql_address           = sq.address 
and   s.sql_hash_value        = sq.hash_value 
order by r.name ;
