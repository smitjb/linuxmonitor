select id, 
       SUBSTR((lpad(' ',2*level) || operation ||decode(id,0,'Cost='||position) ||' '||object_name),1,140)  as "Query Plan"
from plan_table
start with id = 0
connect by prior id = parent_id
and     statement_id = '&ids';
--and     statement_id = 'DES';

PROMPT delete from plan_table;
