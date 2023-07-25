--
-- $Header: /jbs/var/cvs/orascripts/sql/login.sql,v 1.1 2013/01/02 15:19:40 jim Exp $
--
-- This script runs every time you connect to a database in sqlplus
-- provided it is in a directory on SQLPATH, or the current directory.
--
-- Most of the settings are a matter of preference, but the stuff between
-- the "-- don't change this" lines should be left alone unless you
-- know what you are doing. It sets your sqlplus prompt to current user and
-- database. This is an important safety feature!.
--
--
-- $Log: login.sql,v $
-- Revision 1.1  2013/01/02 15:19:40  jim
-- Migrated from utils
--
-- Revision 1.1  2012/05/22 07:47:22  jim
-- First checkin after import
--
-- Revision 1.1.1.1  2005/11/27 10:10:21  jim
-- Migrated from client site
--
-- Revision 1.4  2005/11/14 15:59:15  jim.smith
-- Set feedback off to reduce output to just the required line
--
-- Revision 1.3  2005/11/03 12:09:05  jim.smith
-- added separate dbname variable for use in subsequent scripts
--
-- Revision 1.2  2005/11/02 11:01:07  jim.smith
-- Made login.sql silent
--
-- Revision 1.1  2005/09/30 10:50:34  jim.smith
-- First checkin from active files
--
--
--
-- =======================================================================
set trimspool on
set trimout on
set linesize 150
set pagesize 50
set feedback off
alter session set nls_date_format='dd-Mon-yyyy hh24:mi:ss';
alter session set nls_time_format='hh:mi:ss';

-- don't change this -----------------------------
define newprompt=idle
define dbname=unknown
column global_name new_value newprompt noprint
column db new_value dbname noprint
select lower(user) ||
	'@'
	|| substr(global_name,1,decode(dot,0,length(global_name),dot-1)) global_name,
	 substr(global_name,1,decode(dot,0,length(global_name),dot-1)) db
from (select 	global_name,
		instr(global_name,'.') dot
	from global_name);
set sqlprompt '&newprompt> ';
-- don't change this -----------------------------

set feedback on
set timing on
select * from v$database;