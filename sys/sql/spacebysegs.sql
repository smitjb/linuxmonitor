select owner, segment_name, sum(bytes)
from   dba_extents
where  owner not in ('SYSTEM','SYS')
group by owner, segment_name
order by 3,1,2
/
