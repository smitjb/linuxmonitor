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

spool &1..trg
select line,text 
from user_source 
where name=upper('&1')
and type='TRIGGER'
order by line;
SPOOL OFF
