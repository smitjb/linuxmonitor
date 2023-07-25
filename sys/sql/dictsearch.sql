select owner,view_name from dba_views where view_name like upper('%&&1%')
union
select owner, table_name from dba_tables where table_name like upper('%&&1%');