/*
 * $Header: /jbs/var/cvs/orascripts/sql/A_20_move_undo_tablespace.sql,v 1.1 2013/01/03 12:04:06 jim Exp $
 *
 * Shrink the oversized undo tablespace by replacing it with 
 * a smaller one.
 * 
 * $Log: A_20_move_undo_tablespace.sql,v $
 * Revision 1.1  2013/01/03 12:04:06  jim
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
REM
REM create a new tablespace for undo management
REM
create undo tablespace UNDOTBS2
 datafile '&undodisk:\oracle\oradata\orcl\UNDOTBS2A.dbf' size 100M autoextend on next 10M maxsize unlimited
 extent management local;


REM
REM reduce the undo_retention to 0 to allow a quick switchover to the new file
REM 
alter system set undo_retention=0 scope=both;

REM
REM switch to the new tablespace
REM 
alter system set undo_tablespace = UNDOTBS2
	scope=both;



