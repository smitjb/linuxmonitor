select substr(owner,1,15)        owner,
       substr(segment_name,1,20) segment_name,
       segment_type,
       count(extent_id)          No_of_extents
from   dba_extents
where  owner = 'BOTEMP'
group by owner, segment_type, segment_name
order by owner, segment_type, segment_name;
