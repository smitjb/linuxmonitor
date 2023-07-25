--
-- $Header: /jbs/var/cvs/orascripts/sql/archlogpeak.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
-- 
-- Max, averaage and stddev archivelog rate 
--
-- Defaults to per hour, but DD gives daily
--
define period=&1;

 SELECT name,MAX(vol),
  AVG(vol)      ,
  stddev(vol)
   FROM
  (SELECT trunc(next_time,nvl('&&period','HH')),
    ROUND(SUM(blocks* block_size)/(1024*1024),0) vol
     FROM v$archived_log
    WHERE dest_id=1
 GROUP BY trunc(next_time,nvl('&&period','HH'))
  ), v$database
group by name;
