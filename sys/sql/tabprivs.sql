
spool tabprivs.lis

break on granted_by


SELECT SUBSTR(grantor,1,20) granted_by,
       SUBSTR(privilege,1,10)   privilege,
       ' on ' || SUBSTR(owner,1,20) || '.' || SUBSTR(table_name,1,30) owner_table,
       ' to ' || SUBSTR(grantee,1,20)    grantee_to,
       decode(grantable,'YES','WITH GRANT OPTION',grantable) grantable
FROM   dba_tab_privs
WHERE grantee NOT IN
 ('AQ_ADMINISTRATOR_ROLE',
  'AQ_USER_ROLE',
  'DBA',
  'DBSNMP',
  'DELETE_CATALOG_ROLE',
  'EXECUTE_CATALOG_ROLE',
  'EXP_FULL_DATABASE',
  'IMP_FULL_DATABASE',
  'OPS$ORACLE',
  'PUBLIC','ORDSYS','HS_ADMIN_ROLE',
  'SELECT_CATALOG_ROLE',
  'SNMPAGENT','REPOS',
  'SQLNAV',
  'SQLNAV_ADMIN',
  'SYS',
  'SYSTEM')
and   grantor NOT IN ('REPOS','SYS')
and grantee = 'CSOWNERBS1'
order by grantor, grantee, table_name, privilege
/

break on wind

spool off
