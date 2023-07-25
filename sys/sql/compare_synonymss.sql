select SYNONYM_NAME, TABLE_OWNER,TABLE_NAME
from dba_synonyms 
where owner='&&user1'
MINUS
select SYNONYM_NAME, TABLE_OWNER,TABLE_NAME
from dba_synonyms 
where owner='&&user2';