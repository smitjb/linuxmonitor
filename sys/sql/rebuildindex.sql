break on table_name
select 'ALTER INDEX ' || a.index_name || ' REBUILD;'
from   user_indexes a, 
       user_ind_columns b
where  a.table_name = b.table_name
and    a.index_name = b.index_name
and    a.status    != 'VALID'
/
break on wind
