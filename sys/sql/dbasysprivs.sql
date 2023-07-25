select GRANTEE,
       PRIVILEGE    
from   dba_sys_privs
where  grantee NOT IN
       ('AQ_ADMINISTRATOR_ROLE','CONNECT','DBA','DBSNMP','EXP_FULL_DATABASE',
        'IMP_FULL_DATABASE','OPS$ORACLE','RECOVERY_CATALOG_OWNER','RESOURCE',
        'SNMPAGENT','SQLNAV','SYS','SYSTEM')
order by grantee, 
         privilege
/
