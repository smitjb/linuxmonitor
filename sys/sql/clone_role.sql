prompt "Enter role name"
define rolename=&1
set heading off
set feedback off
set linesize 200
set trimspool on
set trimout on
SET verify off
set timing off
set echo off
set termout off
set title off
SPOOL clone_&&rolename..sql
select 'create role '||role||';' from dba_roles where role=UPPER('&&rolename');
select 'grant '||granted_role||' to '||grantee|| decode(ADMIN_OPTION,'YES',' WITH ADMIN OPTION','')||';' FROM DBA_ROLE_PRIVS WHERE GRANTEE=upper('&&rolename')
UNION
SELECT 'GRANT '||PRIVILEGE||' TO '||GRANTEE||decode(ADMIN_OPTION,'YES',' WITH ADMIN OPTION','')||';' FROM DBA_SYS_PRIVS WHERE GRANTEE=upper('&&rolename')
UNION
SELECT 'GRANT '||PRIVILEGE||' ON '||OWNER||'.'||TABLE_NAME||' TO '||GRANTEE||DECODE(GRANTABLE,'YES',' WITH GRANT OPTION','')||';' FROM DBA_TAB_PRIVS WHERE GRANTEE=upper('&&rolename');
spool off
exit