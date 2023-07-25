select GRANTEE,
       GRANTED_ROLE
from   dba_role_privs
where  granted_role = 'DBA'
order by 1,2
/

