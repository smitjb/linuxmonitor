select 'grant '||privilege||' on '||owner||'.'||table_name ||' TO '  ||GRANTEE||
decode (grantable,'YES',' WITH GRANT OPTION;',';')  
from dba_tab_privs 
where owner=UPPER(nvl('&1',user)) AND TABLE_NAME=UPPER('&2');