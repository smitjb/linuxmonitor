select substr(owner,1,15)           owner,
       substr(tablespace_name,1,10) tablespace_name,
       substr(segment_name,1,30)    segment_name,
       segment_type,
       count(extent_id)          No_of_extents,
       SUM(bytes)                bytes
from   dba_extents
where  owner           = 'CGCRUISEBS1'
and   tablespace_name NOT LIKE 'CG%'
--and    segment_name like 'OT_DOCS%'
group by owner, segment_type, segment_name,tablespace_name
order by owner, segment_type, segment_name;

