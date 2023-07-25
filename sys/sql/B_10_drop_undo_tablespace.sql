/*
 * $Header: /jbs/var/cvs/orascripts/sql/B_10_drop_undo_tablespace.sql,v 1.1 2013/01/03 12:05:11 jim Exp $
 *
 * Get rid of the old undo tablespace.
 * The new tablespace has been made active, and by shutting
 * down the database, any undo segments in this tablespace 
 * will have been released, so the tablespace can be dropped.
 *
 * $Log: B_10_drop_undo_tablespace.sql,v $
 * Revision 1.1  2013/01/03 12:05:11  jim
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
REM get rid of the old tablespace  
REM
drop tablespace UNDOTBS1 including contents and datafiles;

REM
REM set the undo retention to 5 minutes
REM

alter system set undo_retention = 300 
	scope=both;