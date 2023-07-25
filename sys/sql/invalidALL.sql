select owner,
       substr(object_name,1,30) object_name,
       substr(object_type,1,15) object_type,
       status
from   all_objects
where  status = 'INVALID'
or     status = 'DISABLED'
order by 1,3,2;
