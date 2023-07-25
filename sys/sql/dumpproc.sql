--
-- $Header: /jbs/var/cvs/orascripts/sql/dumpproc.sql,v 1.2 2013/01/04 16:17:58 jim Exp $
-- 
-- Extract DDL from dictionary tables
--
set trimout on
set trimspool on
SET TERMOUT OFF
SET HEADING OFF
set pagesize 0
set linesize 250
set confirm off
set verify off
set feedback off

column line noprint

spool &1..prc
select line,text 
from dba_source 
where owner=upper(nvl('&2',USER))
and name=upper('&1')
and type='PROCEDURE'
order by line;
SPOOL OFF
exit