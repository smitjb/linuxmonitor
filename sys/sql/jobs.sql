--
-- $Header: /jbs/var/cvs/orascripts/sql/jobs.sql,v 1.1 2013/01/02 15:11:10 jim Exp $
--
-- This script creates the initial jobs for support of parms release 2 
--
-- The CRAPATCH job is not required until release 3
--
-- $Log: jobs.sql,v $
-- Revision 1.1  2013/01/02 15:11:10  jim
-- Migrated from utils
--
-- Revision 1.1.1.1  2005/11/27 10:10:20  jim
-- Migrated from client sight
--
-- Revision 1.1  2005/07/14 12:14:12  jim.smith
-- first checkin
--
--
--
-- =======================================================================
set serveroutput on
declare 
 jid number;
 begin
 
 dbms_output.put_line('Healthcheck');
 elx_utilities.create_job('HEALTHCHECKS','HEALTHCHECKS',sysdate,sysdate,jid);
 
-- dbms_output.put_line('CRA'); 
-- elx_utilities.create_job('CRAPATCH','CRAPATCH',sysdate,sysdate,jid);
 
 dbms_output.put_line('SETTLE');
 elx_utilities.create_job('SETTLECAL1','SETTLECAL1',sysdate,sysdate,jid);
 
 dbms_output.put_line('MDD');
 elx_utilities.create_job('MDDDUP','MDDDUP',sysdate,sysdate,jid);
end;
