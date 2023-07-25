break on report
compute sum of max_size  current_size on report
select component, min_size,max_size, user_specified_size, current_size 
from v$memory_dynamic_components;

