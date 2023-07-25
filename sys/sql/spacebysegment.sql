select distinct(owner), sum(bytes)
from   dba_segments
where  segment_name = upper('&segname')
group by owner
order by sum(bytes)
/

