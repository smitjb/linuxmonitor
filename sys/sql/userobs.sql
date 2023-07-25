
select object_type, substr(object_name,1,35) object_name, status
from   user_objects
order by 1,2,3;

select distinct(object_type), count(*)
from   user_objects
group by object_type;


