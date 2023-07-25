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
       substr(rs.STATUS,1,8) status,
       rs.CUREXT,
       rs.CURBLK
FROM   v$rollname rn,
       v$rollstat rs
WHERE  rn.name IN (SELECT segment_name
                   FROM   dba_rollback_segs)
AND    rn.usn  = rs.usn;

select substr(TABLESPACE_NAME,1,20) TABLESPACE_NAME, substr(SEGMENT_NAME,1,20) SEGMENT_NAME, 
       substr(INITIAL_EXTENT,1,12) INITIAL_EXT, substr(NEXT_EXTENT,1,12) NEXT_EXT,
       substr(MIN_EXTENTS,1,7) MIN_EXT, substr(MAX_EXTENTS,1,7) MAX_EXT,
       substr(PCT_INCREASE,1,5) PCT, substr(STATUS,1,10) STATUS,
       owner, substr(SEGMENT_ID,1,6) SEG_ID, substr(BLOCK_ID,1,6) BLK_ID, substr(INSTANCE_NUM,1,10) INST_NUM
from   dba_rollback_segs
order by TABLESPACE_NAME, SEGMENT_NAME;

SELECT rn.name, rs.extents, rs.optsize, rs.rssize, rs.status, rs.xacts, rs.hwmsize
FROM   v$rollname rn,
       v$rollstat rs
WHERE  rn.name IN (SELECT segment_name
                   FROM   dba_rollback_segs)
AND    rn.usn  = rs.usn
/

