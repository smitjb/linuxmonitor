/*
 * $Header: /jbs/var/cvs/orascripts/sql/list_log_files.sql,v 1.1 2013/01/02 15:17:57 jim Exp $
 * 
 * Utility script to list the current logfile groups and members
 *
 * $Log: list_log_files.sql,v $
 * Revision 1.1  2013/01/02 15:17:57  jim
 * Migrated from utils
 *
 * Revision 1.1.1.1  2005/11/27 10:10:21  jim
 * Migrated from client sight
 *
 * Revision 1.1  2005/04/15 13:43:01  jim.smith
 * First versions
 *
 * 
 * **********************************************************
 */
col group# format 9990 heading 'Group'
col status format a10 heading 'Status'
col type format a10 heading 'Type'
col filename format a50 heading 'Log file'
select group#,status,type, substr(member,1,50) as filename
from v$logfile
order by 1,4;
