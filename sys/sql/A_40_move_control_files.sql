/*
 * $Header: /jbs/var/cvs/orascripts/sql/A_40_move_control_files.sql,v 1.1 2013/01/03 12:04:20 jim Exp $
 *
 *
 * set the configuration parameter to move control files to separate disks.
 * 
 * After running this script, you need to shut the database down,
 * physically copy the control files to the correct places 
 * and restart the database.
 * 
 * The database won't start if it can't find one of the files.
 *
 * $Log: A_40_move_control_files.sql,v $
 * Revision 1.1  2013/01/03 12:04:20  jim
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
alter system set control_files='c:\oracle\oradata\orcl\control01.ctl','e:\oracle\oradata\orcl\control02.ctl','i:\oracle\oradata\orcl\control03.ctl' scope=spfile;

