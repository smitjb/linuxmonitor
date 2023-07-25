set trimspool on
set trimout on
set linesize 500
set pagesize 0
set timing off
set feedback off
set termout off
set verify off
set long 8000
set arraysize 1
define owner=&1
define name=&2
col text newline
col semicolon newline
spool &name..vue
select 'create or replace force view '||v.owner||'.'|| v.view_name ||' as ',v.text,';' semicolon
from dba_views v 
where v.owner=upper('&owner')
and view_name=upper('&name')
/
spool off
exit