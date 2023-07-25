set feedback off
set linesize 120
set heading  off


spool runseldeleterows.sql

select 'delete from ' || table_name || ' cascade;' from user_tables;

spool off

select substr(global_name,1,20) global_name 
from   global_name;

set linesize 200
set feedback on
set heading  on

prompt .
prompt now run @runseldeleterows.sql
prompt .

