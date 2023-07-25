/*
 * $Header: /jbs/var/cvs/orascripts/sql/B_60_drop_unwanted_tables.sql,v 1.1 2013/01/03 12:05:39 jim Exp $
 *
 * 
 * DROP SPURIOUS TABLES IN THE PARMS SCHEMA
 *
 * $Log: B_60_drop_unwanted_tables.sql,v $
 * Revision 1.1  2013/01/03 12:05:39  jim
 * Migrated from utils
 *
 * Revision 1.1.1.1  2005/11/27 10:10:20  jim
 * Migrated from client sight
 *
 * Revision 1.2  2005/04/15 13:49:17  jim.smith
 * Changed order of tables to work with referential integrity constraints
 *
 * Revision 1.1  2005/04/15 13:43:01  jim.smith
 * First versions
 *
 * 
 * **********************************************************
 */

drop table parms.orders;
drop table parms.mismatches;
drop table parms.salgrade;
drop table parms.employee;
drop table parms.product;
drop table parms.prospect;
drop table parms.customer;
drop table parms.supplier;
drop table parms.department;

