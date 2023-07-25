--
-- $Header: /jbs/var/cvs/orascripts/sql/dumpallviews.sql,v 1.2 2013/01/04 16:17:58 jim Exp $
-- 
-- Extract DDL from dictionary tables
--
set trimspool on
set trimout on
set linesize 500
set pagesize 0
set timing off
set feedback off
set termout off
set long 8000
set arraysize 1
define owner=&1
define db=&2
col text newline
col semicolon newline
spool &db._&owner._views.lst
select 'create force view '||v.owner||'.'|| v.view_name ||' as ',v.text,';' semicolon
from dba_views v 
where v.owner=upper('&owner')
order by v.view_name
/
spool off
exit