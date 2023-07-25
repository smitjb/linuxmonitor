select table_name, num_rows,last_analyzed 
from dba_tables 
where owner=upper('&1')
 order by 3
/
