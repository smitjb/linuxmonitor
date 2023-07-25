break on report
compute sum of mb on report
select tablespace_name,
        owner, 
       substr(segment_name,1,30) SEGMENT, 
       round(bytes/(1024*1024)) mb
FROM DBA_SEGMENTS 
WHERE upper(tablespace_name) like UPPER('%&1')
order by tablespace_name, owner, substr(segment_name,1,30)
/
