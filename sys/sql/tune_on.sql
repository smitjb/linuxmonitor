-- 
-- $Header: /jbs/var/cvs/orascripts/sql/tune_on.sql,v 1.1 2013/01/02 17:52:55 jim Exp $
-- 
-- Change some sqlplus settings for use during tuning sessions
--
-- $Log: tune_on.sql,v $
-- Revision 1.1  2013/01/02 17:52:55  jim
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
set timing on
set autotrace on
alter session set sql_trace=true;

