select owner,
       substr(object_type,1,15) object_type,
       substr(object_name,1,30) object_name,
       status
from   all_objects
where  status = 'INVALID'
--and    owner  like '%MIG%'
order by 2,1;

select owner,
       substr(object_type,1,15) object_type,
       substr(object_name,1,30) object_name,
       status
from   all_objects
where  status = 'INVALID'
--and    owner  like '%CRUISE%'
order by 2,1;

select owner,
       table_name,
       index_name
from   all_indexes
where  status = 'UNUSABLE';

select owner,
       table_name, 
       constraint_type,
       constraint_name 
from   all_constraints 
where  status != 'ENABLED'
order by 1,2,3,4;

