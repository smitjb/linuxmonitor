-- 
-- $Header: /jbs/var/cvs/orascripts/sql/archlograte.sql,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
-- display archive log production rate by period. 
-- Defaults to per hour
-- A parameter of DD gives per hour
define period=&1;

 select trunc(next_time,nvl('&&period','HH')), 
	round(sum(blocks* block_size)/(1024*1024),0) 
from v$archived_log 
where dest_id=1
group by trunc(next_time,nvl('&&period','HH'));
