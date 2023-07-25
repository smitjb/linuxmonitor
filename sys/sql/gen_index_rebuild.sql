define own=&1;
define tblspc=&2;

select 'ALTER INDEX ' ||a.owner||'.'|| a.index_name || ' REBUILD tablespace &tblspc;'
from   dba_indexes a, 
       dba_ind_columns b
where  a.table_name = b.table_name
and    a.index_name = b.index_name
and a.owner=upper('&own');

