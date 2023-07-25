select  owner,view_name from dba_views where view_name like ('%&1%')
UNION
SELECT owner,TABLE_NAME FROM DBA_TABLES WHERE TABLE_NAME LIKE upper('%&%')
/
