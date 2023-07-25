--
-- $Header: /jbs/var/cvs/orascripts/sql/dumpalltables.sql,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
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
spool &db._&owner._tables.lst
select t.table_name,column_name, data_type,data_length,data_precision, data_scale,nullable
from dba_tables t 
	inner join dba_tab_cols c 
            on t.owner=c.owner 
           and t.table_name=c.table_name
where t.owner='&owner'
order by t.table_name, column_name
/
spool off
exit