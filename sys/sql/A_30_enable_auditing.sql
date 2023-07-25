/*
 * $Header: /jbs/var/cvs/orascripts/sql/A_30_enable_auditing.sql,v 1.1 2013/01/03 12:04:13 jim Exp $
 *
 * enable the internal audit trail table so we can do 
 * connection auditing
 *
 * $Log: A_30_enable_auditing.sql,v $
 * Revision 1.1  2013/01/03 12:04:13  jim
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

alter system set audit_trail=DB scope=spfile;

