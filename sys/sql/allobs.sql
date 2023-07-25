select owner, object_type, substr(object_name,1,35) object_name, status
from   dba_objects
where  owner = upper('&owner')
order by 1,2,3
/
