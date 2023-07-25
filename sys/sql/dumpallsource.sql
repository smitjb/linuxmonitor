--
-- $Header: /jbs/var/cvs/orascripts/sql/dumpallsource.sql,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
-- 
-- Extract DDL from dictionary tables
--
set trimspool on
set trimout on
set linesize 250
set pagesize 0
set timing off
set feedback off
set termout off
define owner=&1
define db=&2
spool &db._&owner._source.lst
select s.type,s.name,s.line,s.text
from dba_source s 
where s.owner='&owner'
order by s.type,s.name,s.line
/
spool off
exit