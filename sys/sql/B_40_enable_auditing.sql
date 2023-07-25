/*
 * $Header: /jbs/var/cvs/orascripts/sql/B_40_enable_auditing.sql,v 1.1 2013/01/03 12:05:32 jim Exp $
 *
 * Having set the configuration parameters to enable auditing
 * now actually switch it on. For connection attempts only.
 * $Log: B_40_enable_auditing.sql,v $
 * Revision 1.1  2013/01/03 12:05:32  jim
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
audit connect;