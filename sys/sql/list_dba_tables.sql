select table_name from dba_tables where table_name like '%PRIV%' union select view_name from dba_views where view_name like '%PRIV%'
/
