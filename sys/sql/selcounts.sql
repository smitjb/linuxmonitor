set feedback off
set linesize 120


spool runselcounts.sql

select 'select count(*) ' || table_name || ' from ' || table_name || ';' from user_tables;

spool off

set linesize 200
set feedback on
set heading  on

prompt .
prompt .
prompt now run @runselcounts.sql
prompt .
