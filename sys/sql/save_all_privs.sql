set linesize 200
set pagesize 0
set timing off
set termout off
spool all_grants_&1
select * from dba_tab_privs
order by grantee, owner, table_name, privilege;
spool off
