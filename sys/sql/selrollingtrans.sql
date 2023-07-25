--If the value for the column  "USED_UBLK" in V$TRANSACTION is decreasing, then 
--that transaction is being rolled back.


SELECT SES_ADDR, XIDUSN, name, USED_UBLK from V$TRANSACTION,v$rollname where xidusn=usn;


 --SELECT * FROM V$ROLLNAME WHERE USN IN (select xidusn from v$transaction);

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
and   sq.hash_value(+) = s.sql_hash_value
and   s.SADDR IN (select ses_addr from v$transaction);

