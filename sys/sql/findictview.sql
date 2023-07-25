--
-- $Header: /jbs/var/cvs/orascripts/sql/findictview.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
-- 
-- Find a vdictionary view or table
--
select view_name
from dba_views
where view_name like upper('%&&1%')
union
select table_name
from dba_tables
where table_name like upper('%&&1%');
