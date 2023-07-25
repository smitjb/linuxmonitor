--
-- $Header: /jbs/var/cvs/orascripts/sql/dumppkg.sql,v 1.2 2013/01/04 16:17:58 jim Exp $
--
-- 
-- $Log: dumppkg.sql,v $
-- Revision 1.2  2013/01/04 16:17:58  jim
-- Added logon time reformatted
--
-- Revision 1.1.1.1  2012/12/28 17:34:15  jim
-- First import
--
--
-- =======================================================================
set trimout on
set trimspool on
SET TERMOUT OFF
SET HEADING OFF
set pagesize 0
set linesize 500
set confirm off
set verify off
set feedback off
set timing off
column line noprint

spool &1..pkb
select line,text 
from dba_source 
where name=upper('&1')
and type='PACKAGE BODY'
and owner=upper(nvl('&2',USER))
order by line;
spool &1..pkg

select line,text 
from dba_source 
where name=upper('&1')
and type='PACKAGE'
and owner=upper(nvl('&2',USER))
order by line;
SPOOL OFF
exit
