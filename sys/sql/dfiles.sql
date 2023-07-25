select substr(TABLESPACE_NAME,1,25) tablespace,
       INITIAL_EXTENT,
       NEXT_EXTENT,
       MIN_EXTENTS,
       MAX_EXTENTS,
       PCT_INCREASE,
       MIN_EXTLEN,
       STATUS,
       CONTENTS,
       LOGGING,
       EXTENT_MANAGEMENT,
       ALLOCATION_TYPE,
       PLUGGED_IN
from   dba_tablespaces;

select substr(FILE_NAME,1,55) filename,
       substr(FILE_ID,1,2) f#,
       substr(TABLESPACE_NAME,1,15) tablespace,
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
UNION
select substr(FILE_NAME,1,55) filename,
       substr(FILE_ID,1,2) f#,
       substr(TABLESPACE_NAME,1,15) tablespace,
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
FROM   dba_temp_files
order by 3,1,2;

