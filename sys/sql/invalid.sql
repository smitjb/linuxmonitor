select owner,
       object_type,
       substr(object_name,1,30) object_name,
       status
from   dba_objects
where  (status = 'INVALID'
OR     status = 'DISABLED')
and owner like upper('%&1%')
order by 1,2,3;




