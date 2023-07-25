select owner, sum(bytes)
from   dba_extents
group by owner
order by 2,1;
