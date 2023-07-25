--
-- $Header: /jbs/var/cvs/orascripts/sql/invalidlist.sql,v 1.2 2013/01/04 16:17:58 jim Exp $
--
-- List all invalid objects
--
select owner,
       object_type,
       substr(object_name,1,30) object_name,
       status
from   dba_objects
where  (status = 'INVALID'
OR     status = 'DISABLED')
and owner like upper('%&1%')
order by 1,2,3;




