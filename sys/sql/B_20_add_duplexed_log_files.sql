/*
 * $Header: /jbs/var/cvs/orascripts/sql/B_20_add_duplexed_log_files.sql,v 1.1 2013/01/03 12:05:18 jim Exp $
 *
 * 
 * add an extra member to each log group for resilience
 * 
 * $Log: B_20_add_duplexed_log_files.sql,v $
 * Revision 1.1  2013/01/03 12:05:18  jim
 * Migrated from utils
 *
 * Revision 1.1.1.1  2005/11/27 10:10:20  jim
 * Migrated from client sight
 *
 * Revision 1.1  2005/04/15 13:43:00  jim.smith
 * First versions
 *
 * 
 * **********************************************************
 */
set echo on
set termout on
spool add_duplexed_log_files

@@list_log_files
@@add_log_file_member  &&redodisk:\oracle\oradata\orcl\redo01.log 1
@@list_log_files
@@add_log_file_member  &&redodisk:\oracle\oradata\orcl\redo02.log 2
@@list_log_files
@@add_log_file_member  &&redodisk:\oracle\oradata\orcl\redo03.log 3
@@list_log_files

alter system switch logfile;
alter system switch logfile;
alter system switch logfile;

@@list_log_files


spool off
