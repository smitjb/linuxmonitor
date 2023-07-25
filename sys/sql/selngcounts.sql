select 'select count(*) ' || table_name || ' from ' || table_name || ';' 
from   user_tables 
where  table_name like 'NGPUB%'
OR     table_name like 'NGSUB%';

