--
-- $Header: /jbs/var/cvs/orascripts/sql/gen_contacts_data.sql,v 1.1 2013/01/02 14:59:09 jim Exp $
--
-- Extract parms contacts test data the form of insert statements
-- Suitable for PARMS V3.7-3.9
-- 
-- $Log: gen_contacts_data.sql,v $
-- Revision 1.1  2013/01/02 14:59:09  jim
-- Migrated from utils
--
-- Revision 1.1.1.1  2005/11/27 10:10:20  jim
-- Migrated from client sight
--
--
--
-- =======================================================================
set heading off
set pagesize 1000
set trimout on
set trimspool on
set feedback off
set termout off
alter session set NLS_DATE_FORMAT='dd Month yyyy hh24:mi:ss';
select sysdate from dual;
select parmsversion from parms.parmsversion;
col parmsversion form a10 new_value vers
col sysdate form a17 new_value extract_date
select sysdate from dual;
select parmsversion from parms.parmsversion;

ttitle left rem skip  -
	left 'rem ----- Extracted from parms version ' vers ' on ' extract_date skip -
        left rem skip 2


spool load_contacts_data.sql
@@gen_load_tradingparty
@@gen_load_contacts
@@gen_load_parmscontacts
spool off
exit
