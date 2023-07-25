--
-- $Header: /jbs/var/cvs/orascripts/sql/dumpfunction.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
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

spool &1..fun
select line,text 
from user_source 
where name=upper('&1')
and type='FUNCTION'
order by line;
SPOOL OFF
