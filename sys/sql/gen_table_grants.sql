--
-- $Header: /jbs/var/cvs/orascripts/sql/gen_table_grants.sql,v 1.1 2013/01/02 14:55:58 jim Exp $
--
-- Grant select access to all tables in a schema to a named user or role
-- Usage
--  sqlplus u/p @gen_table_grants sqldir tmpdir schema user_or_role 
--
--  This is run as part of creating a read only role, and needs to be 
--  re-run if tables are added to the schema
--
-- It doesn't do views, sequences etc
--
-- $Log: gen_table_grants.sql,v $
-- Revision 1.1  2013/01/02 14:55:58  jim
-- Migrated from utils
--
-- Revision 1.1  2012/05/22 07:47:22  jim
-- First checkin after import
--
-- Revision 1.1.1.1  2005/11/27 10:10:20  jim
-- Migrated from client sight
--
-- Revision 1.1  2005/08/11 15:02:43  jim.smith
-- Migrated from utils project
--
--
--
-- =======================================================================
set heading off
set pagesize 500
set echo off
set termout off
set feedback off
SET CONFIRM OFF

define sqldir = &1
define tmpdir = &2
define schema = &3
define user_or_role=&4

-- grant the object privileges
spool &&tmpdir\do_table_grants.sql

select 'grant select on &&schema..'|| table_name|| ' to &user_or_role;'
from   dba_tables 
where owner=upper('&&schema');
spool off
@&&tmpdir\do_table_grants
exit
