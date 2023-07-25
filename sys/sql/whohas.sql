--
-- $Header: /jbs/var/cvs/orascripts/sql/whohas.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
-- 
-- Total space usage by schema
--
SELECT o.owner,
  round(s.bytes) MB
FROM
  (SELECT DISTINCT owner
   FROM dba_objects) o ,
  (SELECT owner,
     SUM(bytes) /(1024 *1024) bytes
   FROM dba_segments
   where segment_type NOT IN ( 'TYPE2 UNDO','ROLLBACK')
   GROUP BY owner) s 
where o.owner = s.owner(+)
order by o.owner
/

