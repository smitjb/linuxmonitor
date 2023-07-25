rem ttitle "ROLLBACK SEGMENT USAGE BY TRANSACTIONS" 
COLUMN "RBSeg" 		FORMAT a9 
COLUMN "Sid,Serial/Pid" FORMAT a14 
COLUMN "Username/Osuser" format a18 
COLUMN "OsPid" 		FORMAT a5 
COLUMN "UsrPid/OSProg" 	FORMAT A33 
COLUMN "sql_text"       for a50 wrap 

SELECT r.name "RBSeg", 
       s.sid , s.serial#,  p.pid, 
       s.username ||' '|| s.osuser "Username/Osuser", 
       p.spid "OSPid", 
       s.process ||','|| SUBSTR(s.program,1,27) "UsrPid/Osprog", 
       sq.sql_text sql_text 
FROM   v$session s, 
       v$process p, 
       v$transaction t, 
       v$sqlarea sq, 
       v$rollname r 
WHERE p.addr = s.paddr 
and   t.addr = s.taddr 
and   r.usn = t.xidusn 
and   sq.address(+) = s.sql_address 
and   sq.hash_value(+) = s.sql_hash_value;


