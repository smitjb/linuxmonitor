break on report
compute sum of mb on report
select owner, 
       tablespace_name,
       substr(segment_name,1,30) segment_name,
       round(bytes/(1024*1024),2) MB
from  dba_segments
where owner like upper('%&2%')
and segment_name like upper('%&1%')
order by round(bytes/(1024*1024),2);