select substr(name,1,50) name, status 
from v$controlfile;

select group#,
       status,
       substr(member,1,50) member
from   v$logfile
order by group#; 


select GROUP#,
       THREAD#,
       SEQUENCE#,
       BYTES,
       MEMBERS,
       ARCHIVED,
       STATUS,
       FIRST_CHANGE#,
       substr(to_char(FIRST_TIME,'DD-MON-YYYY HH24:MI:SS'),1,22) first_time
from   v$log
order by first_time;

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

select substr(TABLESPACE_NAME,1,25) tablespace,
       INITIAL_EXTENT,
       NEXT_EXTENT,
       substr(MIN_EXTENTS,1,7) MIN_EXT,
       MAX_EXTENTS,
       substr(PCT_INCREASE,1,3) pct,
       STATUS,
       CONTENTS,
       LOGGING,
       EXTENT_MANAGEMENT,
       ALLOCATION_TYPE,
       PLUGGED_IN
from   dba_tablespaces;

select substr(FILE_NAME,1,30) filename,
       substr(FILE_ID,1,2) f#,
       substr(TABLESPACE_NAME,1,25) tablespace,
       BYTES,
       BLOCKS,
       STATUS,
       substr(RELATIVE_FNO,1,2) rf,
       AUTOEXTENSIBLE,
       substr(MAXBYTES,1,7)     MAXBYTS,
       substr(MAXBLOCKS,1,7)    MAXBLKS,
       substr(INCREMENT_BY,1,6) INC_BY,
       USER_BYTES,
       USER_BLOCKS
FROM   dba_data_files
order by tablespace_name, file_id;

