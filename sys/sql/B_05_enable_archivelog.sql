/*
 * $Header: /jbs/var/cvs/orascripts/sql/B_05_enable_archivelog.sql,v 1.1 2013/01/03 12:05:04 jim Exp $
 *
 * Having set the supporting parameters, now bounce the database
 * enable archiving of logs.
 *
 * $Log: B_05_enable_archivelog.sql,v $
 * Revision 1.1  2013/01/03 12:05:04  jim
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

startup mount exclusive;

alter database archivelog;
archive log list;
archive log start;

shutdown
startup