--
-- $Header: /jbs/var/cvs/orascripts/sql/dumpallindexes.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
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
col column_name format a40
define owner=&1
define db=&2
spool &db._&owner._indexes.lst
select i.table_name,i.index_name,uniqueness,column_position,column_name
from dba_indexes i
	inner join dba_ind_columns c 
            on i.owner=c.index_owner 
           and i.index_name=c.index_name
where i.owner='&owner'
order by i.table_name, i.index_name,column_position, column_name
/
spool off
exit