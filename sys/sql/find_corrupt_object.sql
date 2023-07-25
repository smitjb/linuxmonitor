select segment_type,owner,segment_name
from dba_extents
where file_id = &1 and &2 between block_id and block_id+blocks -1;
