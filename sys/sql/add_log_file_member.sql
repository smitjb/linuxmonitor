/*
 * $Header: /jbs/var/cvs/orascripts/sql/add_log_file_member.sql,v 1.1 2013/01/02 13:48:19 jim Exp $
 *
 * Utility script to add a logfile member to an existing group.
 * Parameters
 *   1  the name of the log file
 *   2  the group number. 
 *
 * $Log: add_log_file_member.sql,v $
 * Revision 1.1  2013/01/02 13:48:19  jim
 * Migrated from utils
 *
 * Revision 1.1.1.1  2005/11/27 10:10:20  jim
 * Migrated from client sight
 *
 * Revision 1.1  2005/04/15 13:43:01  jim.smith
 * First versions
 *
 * 
 * **********************************************************
 */

alter database add logfile member '&1' 
to group &2;

