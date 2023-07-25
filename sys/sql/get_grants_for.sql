select grantee,table_name,privilege,grantable 
from dba_tab_privs 
where owner=UPPER(nvl('&1',user)) AND TABLE_NAME=UPPER('&2');
