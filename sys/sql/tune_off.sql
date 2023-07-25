-- 
-- $Header: /jbs/var/cvs/orascripts/sql/tune_off.sql,v 1.1 2013/01/02 17:52:48 jim Exp $
-- 
-- Revert to non-tuneing mode
--
-- $Log: tune_off.sql,v $
-- Revision 1.1  2013/01/02 17:52:48  jim
-- Migrated from utils
--
-- Revision 1.1  2012/05/22 07:47:23  jim
-- First checkin after import
--
-- Revision 1.1.1.1  2005/11/27 10:10:21  jim
-- Migrated from client sight
--
-- Revision 1.1  2005/07/12 16:38:56  jim
-- First versions
--
-- 
-- 
-- 
-- ===================================================================
set timing off
set autotrace ff
alter session set sql_trace=false;

