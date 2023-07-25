select tablespace_name, sum(bytes)
from   dba_free_space
group by tablespace_name
order by sum(bytes);
