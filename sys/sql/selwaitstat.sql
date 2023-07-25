select class, count from v$WAITSTAT where class in
            ('undo header','undo block','system undo header',
             'system undo block');

select sum(value) "Data Requests" from v$SYSSTAT
   	    where name in ('db block gets', 'consistent gets');

select * from v$waitstat;

select substr(rs.USN,1,5) usn,
       substr(rn.name,1,10)   name,
       substr(rs.EXTENTS,1,5) exnts,
       rs.RSSIZE,
       rs.WRITES,
       rs.XACTS,
       rs.GETS,
       rs.WAITS,
       rs.OPTSIZE,
     --rs.HWMSIZE,
       rs.SHRINKS,
       rs.WRAPS,
       rs.EXTENDS,
       rs.AVESHRINK,
       rs.AVEACTIVE  highwmark,
       substr(rs.STATUS,1,8) status
     --rs.CUREXT,
     --rs.CURBLK
FROM   v$rollname rn,
       v$rollstat rs
WHERE  rn.name IN (SELECT segment_name
                   FROM   dba_rollback_segs)
AND    rn.usn  = rs.usn;
