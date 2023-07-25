break on table_name
select a.table_name,
       a.uniqueness,
       a.index_name,
       substr(b.column_name,1,30) column_name,
       substr(b.column_position,1,3) pos
from   user_indexes a, 
       user_ind_columns b
where  a.table_name = b.table_name
and    a.index_name = b.index_name
order by 1,3,5
/
break on wind
