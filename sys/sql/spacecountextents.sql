select count(distinct(segment_name)), segment_name, owner
from   dba_extents
where  owner not in ('SYSTEM','SYS')
group by owner, segment_name
/
