define username=&1
set heading off
set feedback off
set linesize 200
set trimspool on
set trimout on
SET verify off
set timing off
set echo off
set termout off
SPOOL clone_&&username..sql
select 'spool clone_&&username' from dual;
select ' prompt create user' from dual;
select 'create user ' ||username
      ||' identified '||decode(password,'EXTERNAL','externally','by values '''||password||'''')
      ||' account lock'
      ||';'
from dba_users
where username=upper('&&username');

select ' prompt default tablespaces and profile' from dual;

select 'alter user '||username
        ||' default tablespace '||default_tablespace
        ||' temporary tablespace '||temporary_tablespace
        ||' profile '||profile
        ||';' 
from dba_users 
where username=upper('&&username');

select ' prompt tablespaces quotas' from dual;
select 'alter user '||username
      ||' quota '|| decode(max_bytes,-1,'unlimited ', to_char(max_bytes))
      ||' on '||tablespace_name
      ||';'
from dba_ts_quotas
where username=upper('&&username');

select ' prompt roles and privileges' from dual;
select 'grant '
      ||granted_role||' to '
      ||grantee|| decode(ADMIN_OPTION,'YES',' WITH ADMIN OPTION','')||';' 
FROM DBA_ROLE_PRIVS WHERE GRANTEE=upper('&&username')
UNION
SELECT 'GRANT '||PRIVILEGE||' TO '
        ||GRANTEE||decode(ADMIN_OPTION,'YES',' WITH ADMIN OPTION','')||';' 
FROM DBA_SYS_PRIVS WHERE GRANTEE=upper('&&username')
UNION
SELECT 'GRANT '||PRIVILEGE||' ON '||OWNER||'.'||TABLE_NAME||' TO '
      ||GRANTEE||DECODE(GRANTABLE,'YES',' WITH GRANT OPTION','')||';' 
FROM DBA_TAB_PRIVS WHERE GRANTEE=upper('&&username');


select ' prompt unlock account' from dual;
select 'alter user '||username
        ||' account unlock'
        ||';' 
from dba_users 
where username=upper('&&username');

select ' prompt done' from dual;
select 'spool off' from dual;
spool off