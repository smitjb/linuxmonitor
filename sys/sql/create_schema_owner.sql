-- 
-- $Header: /jbs/var/cvs/orascripts/sql/create_schema_owner.sql,v 1.1 2013/01/02 14:20:40 jim Exp $
-- 
--
-- Script to create an oracle user which will own application objects
--
-- Written in PL/SQL to handle potentially complex parameters.
--
-- Parameters
-- 1 new username
-- 2 new password
-- 3 default tablespace 
-- 4 other tablespaces (comma separated list)
-- 5 privileges (comma separated list)
--
-- Roles and Privileges
--
-- Needs RESOURCE role, or
--
-- +create session
-- *+CREATE CLUSTER
-- +CREATE DATABASE LINK
-- CREATE DIMENSION
-- CREATE EVALUATION CONTEXT
-- *CREATE INDEXTYPE
-- CREATE LIBRARY
-- *CREATE OPERATOR
-- *CREATE PROCEDURE
-- CREATE PUBLIC SYNONYM
-- CREATE ROLLBACK SEGMENT
-- CREATE RULE SET
-- CREATE SECURITY PROFILE
-- *+CREATE SEQUENCE
-- CREATE SNAPSHOT
-- +CREATE SYNONYM
-- *+CREATE TABLE
-- CREATE TABLESPACE
-- *CREATE TRIGGER
-- *CREATE TYPE
-- +CREATE VIEW
--
-- * granted as part of RESOURCE role in 9i
-- + granted as part of CONNECT role in 9i
--
-- Profiles and Resources
-- 
-- Needs quota (either unlimited or a size on one or more tablespaces)
-- 
-- $Log: create_schema_owner.sql,v $
-- Revision 1.1  2013/01/02 14:20:40  jim
-- Migrated from utils
--
-- Revision 1.1  2012/05/22 07:47:22  jim
-- First checkin after import
--
-- 
-- 
-- 
-- ===================================================================

declare
 type tslist is table of varchar2(30);
 newuser varchar2(30);
 newpass varchar2(30);
 deftablespace varchar2(30);
-- alltablespaces ts_list:='&4';
 alltablespaces varchar2(500);
 allprivs varchar2(2000);
 tstable tslist;
 tsindex number(2);
 tsnext varchar2(30);
begin
  newuser:='&1';
  newpass:='&2';
  deftablespace:='&3';
  alltablespaces:='&4';
  allprivs:='&5';

 -- create the user
  begin
	execute immediate 'create user '||newuser||' identified by '||newpass;
  exception
    when others then raise;
  end;

 
 -- modify the profile
 -- the comma separated list of tablespaces needs to be put into an array
 --
  begin
  tsindex:=1;
  tstable:=new tslist();
  while instr(alltablespaces,',') > 0 
  loop
    tsnext:=substr(alltablespaces,1,instr(alltablespaces,',')-1);
    alltablespaces:=substr(alltablespaces,instr(alltablespaces,',')+1);
    tstable.extend;
    tstable(tsindex):=tsnext;
    tsindex:=tsindex+1;
  end loop;
  if length(alltablespaces) > 0 then
    tstable.extend;
    tstable(tsindex):=alltablespaces;
  end if;
 end;
  begin
	execute immediate 'alter user '||newuser||' default tablespace  '||deftablespace||
		' quota unlimited on '||deftablespace;
        for x in tstable.first..tstable.last
	loop
	execute immediate 'alter user '||newuser||' quota unlimited on '||tstable(x);
	end loop;
  exception
    when others then raise;
  end;

 -- grant the necessary privileges
 -- the privileges are in a comma separated list ('create table,create session') 
 -- which can simply slot into the grant statement
  begin
   execute immediate 'grant '||allprivs||' to '||newuser;
  exception
    when others then raise;
  end;
end;
/