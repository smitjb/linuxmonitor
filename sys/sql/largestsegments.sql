select distinct(substr(segment_name,1,30)),
       substr(owner,1,15),
       substr(segment_type,1,10),
       sum(bytes)
from dba_segments
where  owner not in ('SYS','SYSTEM')
group by segment_name, owner, segment_type
order by sum(bytes) desc
/
