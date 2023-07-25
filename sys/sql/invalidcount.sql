--
-- $Header: /jbs/var/cvs/orascripts/sql/invalidcount.sql,v 1.2 2013/01/04 16:17:58 jim Exp $
--
-- Count all invalid objects
--
break on report
compute sum of cnt on report
SELECT owner,
  COUNT(*) cnt
FROM dba_objects
WHERE status<> 'VALID'
GROUP BY owner; 
clear breaks
