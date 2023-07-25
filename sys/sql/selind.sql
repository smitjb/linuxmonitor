select a.owner,
	   a.table_name,
       a.uniqueness,
       a.index_name,
       substr(b.column_name,1,30) column_name,
       substr(b.column_position,1,3) pos
from   dba_indexes a, 
       dba_ind_columns b
where  a.owner = 'RDOWNERBS1'
and    a.index_name = b.index_name
and    a.index_name = b.index_name
and    a.table_name = upper('&tablename')
order by 2,3
/

