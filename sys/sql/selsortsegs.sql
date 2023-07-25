select substr(TABLESPACE_NAME,1,15) tablespace_name,
       total_extents,
       used_extents,
       free_extents,
       TOTAL_BLOCKS,
       USED_BLOCKS,
       FREE_BLOCKS
from   v$sort_segment;
