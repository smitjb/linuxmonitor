--
-- $Header: /jbs/var/cvs/orascripts/sql/whosusing.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
-- 
-- Tablespace usage by schema and segment type
--

break on tablespace_name skip 1 on owner skip 1
compute sum of MB on tablespace_name
select Tablespace_name,OWNER , segment_type,round(sum(bytes)/(1024*1024)) MB
from dba_segments 
where tablespace_name like upper('%&1%')
GROUP BY tablespace_name,OWNER,segment_type
order by tablespace_name,owner,segment_type
/
