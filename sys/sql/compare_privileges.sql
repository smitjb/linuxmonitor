
(select OWNER,TABLE_NAME,PRIViLEGE 
from dba_tab_privs
where grantee='&&USER1'
MINUS
select OWNER,TABLE_NAME,PRIViLEGE 
from dba_tab_privs
where grantee='&&USER2')
UNION
(select OWNER,TABLE_NAME,PRIViLEGE 
from dba_tab_privs
where grantee='&&USER2'
MINUS
select OWNER,TABLE_NAME,PRIViLEGE 
from dba_tab_privs
where grantee='&&USER1'
);
