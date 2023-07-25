
select distinct sequence#,  first_time,next_time, blocks*block_size size
from v$archived_log;

