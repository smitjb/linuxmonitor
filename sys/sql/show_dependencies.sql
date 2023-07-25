 select * 
from dba_dependencies
WHERE LEVEL < 5
connect by PRIOR NAME=REFERENCED_NAME
AND OWNER=REFERENCED_OWNER
start WITH referenced_name='&1';
