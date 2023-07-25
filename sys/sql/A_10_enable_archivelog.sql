/*
 * $Header: /jbs/var/cvs/orascripts/sql/A_10_enable_archivelog.sql,v 1.1 2013/01/03 12:03:59 jim Exp $
 *
 * Set up the parameters for log archiving
 * $Log: A_10_enable_archivelog.sql,v $
 * Revision 1.1  2013/01/03 12:03:59  jim
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

alter system set log_archive_starts=true scope=spfile;
alter system set log_archive_dest='&archivedisk:\archive' scope=spfile;
