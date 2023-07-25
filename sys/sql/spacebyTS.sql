select tablespace_name, file_name, file_size, meg, ceil((meg/file_size)*100)||'%' pct
from (select d.tablespace_name
            ,d.file_name
            ,floor(d.bytes/1048576)        file_size
            ,floor(sum(f.bytes) / 1048576) meg
     from dba_free_space f
         ,dba_data_files d
     where f.file_id(+) = d.file_id
     and   d.tablespace_name like '&TSname%'
     group by d.tablespace_name
             ,d.file_name
             ,d.bytes)
/
