select sequence_owner, sequence_name, min_value, max_value, increment_by, cycle_flag,order_flag,cache_size,last_number
from dba_sequences
order by sequence_owner,sequence_name
/
