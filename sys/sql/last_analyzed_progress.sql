select table_name, num_rows,last_analyzed 
from dba_tables 
where owner=upper('&1')
and nvl(last_analyzed,sysdate-5) < sysdate -4
 order by 3
/
