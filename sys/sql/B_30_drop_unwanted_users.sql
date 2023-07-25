/*
 * $Header: /jbs/var/cvs/orascripts/sql/B_30_drop_unwanted_users.sql,v 1.1 2013/01/03 12:05:25 jim Exp $
 *
 * 
 * drop all the demo users etc
 * 
 * $Log: B_30_drop_unwanted_users.sql,v $
 * Revision 1.1  2013/01/03 12:05:25  jim
 * Migrated from utils
 *
 * Revision 1.1.1.1  2005/11/27 10:10:20  jim
 * Migrated from client sight
 *
 * Revision 1.2  2005/04/18 15:00:50  jim.smith
 * fixed type in qs_adm name. (was cs_adm)
 *
 * Revision 1.1  2005/04/15 13:43:00  jim.smith
 * First versions
 *
 * 
 * **********************************************************
 */
drop user scott cascade;
drop user hr cascade;
drop user sh cascade;
drop user oe cascade;
drop user pm cascade;
drop user sh cascade;
drop user qs_ws cascade;
drop user qs_os cascade;
drop user qs_cs cascade;
drop user qs_cb cascade;
drop user qs_cbadm cascade;
drop user qs_adm cascade;
drop user qs cascade;


