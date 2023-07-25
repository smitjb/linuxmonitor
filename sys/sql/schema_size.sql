select owner, sum(bytes)/(1024*1024) from dba_segments group by owner
/
