select tablespace_name,OWNER , segment_type,sum(bytes)/(1024*1024) 
from dba_segments 
where owner like upper('%&1%')
GROUP BY tablespace_name,OWNER,segment_type
order by owner,tablespace_name,segment_type
/
