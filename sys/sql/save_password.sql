spool &&1..sql
select 'alter user &&1 identified by values '''||password||''';' from dba_users where username=UPPER('&&1');
spool off
alter user &&1 identified by &&2;