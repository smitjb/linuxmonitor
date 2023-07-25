col referenced_owner newline
col referenced_name format a30
select * from dba_dependencies
where referenced_name =upper('&1')
/
