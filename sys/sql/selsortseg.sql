select TABLESPACE_NAME,
       TOTAL_BLOCKS,
       USED_BLOCKS,
       FREE_BLOCKS
from   v$sort_segment;

