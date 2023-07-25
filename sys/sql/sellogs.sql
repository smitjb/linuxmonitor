select substr(TABLESPACE_NAME,1,20) TABLESPACE_NAME, substr(SEGMENT_NAME,1,20) SEGMENT_NAME, 
       substr(INITIAL_EXTENT,1,12) INITIAL_EXT, substr(NEXT_EXTENT,1,12) NEXT_EXT,
       substr(MIN_EXTENTS,1,7) MIN_EXT, substr(MAX_EXTENTS,1,7) MAX_EXT,
       substr(PCT_INCREASE,1,5) PCT, substr(STATUS,1,10) STATUS,
       owner, substr(SEGMENT_ID,1,6) SEG_ID, substr(BLOCK_ID,1,6) BLK_ID, substr(INSTANCE_NUM,1,10) INST_NUM
from   dba_rollback_segs
order by TABLESPACE_NAME, SEGMENT_NAME;

SELECT rn.name, rs.extents, rs.optsize, rs.rssize
FROM   v$rollname rn,
       v$rollstat rs
WHERE  rn.name IN (SELECT segment_name
                   FROM   dba_rollback_segs)
AND    rn.usn  = rs.usn
/

