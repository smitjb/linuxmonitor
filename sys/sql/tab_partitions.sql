select * 
from dba_tab_partitions 
where table_name=upper('&&1')
and owner=upper(nvl('&&2',user))
/
