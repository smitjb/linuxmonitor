/*
 * $Header: /jbs/var/cvs/orascripts/sql/B_80_move_indexes.sql,v 1.1 2013/01/03 12:05:46 jim Exp $
 *
 * 
 * move two misplaced indexes back to where the belong
 *
 * $Log: B_80_move_indexes.sql,v $
 * Revision 1.1  2013/01/03 12:05:46  jim
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

alter index emailtype2contacttype_FK
 rebuild tablespace PARMS_INDEX;

alter index contacttype_PK
 rebuild tablespace PARMS_INDEX;



