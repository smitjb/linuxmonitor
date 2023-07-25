@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/gen_table_grants.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM Grant select access to all tables in a schema to a named user or role
REM Usage
REM gen_table_grants dbuser dbpassword newrole schema
REM
REM
REM It doesn't do views, sequences etc
REM 
REM
REM $Log: gen_table_grants.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.2  2005/09/21 09:16:35  jim.smith
REM Added standard environment and command line processing
REM
REM Revision 1.1  2005/08/11 14:58:29  jim.smith
REM Migrated from utils project
REM
REM
REM
REM
REM =====================================================================

echo gen_table_grants.bat $Revision: 1.1.1.1 $
echo .

set TEMPSQLPATH=%SQLPATH%
set WORKINGDRIVE=%~d0
set WORKINGDIR=%~p0


pushd %WORKINGDRIVE%%WORKINGDIR%

call ..\etc\setupenv

REM Handle the command line

if "%1" == "" goto nouser
set user=%1
if "%2" == "" goto nopass
set pass=%2
if "%3" == "" goto norole
set ROLE_TO_CREATE=%3
if "%4" == "" goto norole
set SCHEMA_TO_GRANT=%4
goto main
:nouser
set /p user=Username?
:nopass
set /p pass=Password?
:norole
set /p  ROLE_TO_CREATE=User or role?
:noschema
set /p  SCHEMA_TO_GRANT=Schema to grant?
:main


sqlplus %user%/%user% @%ELX_SQLDIR%\gen_table_grants %ELX_SQLDIR% %ELX_TMPDIR%  %SCHEMA_TO_GRANT% %ROLE_TO_CREATE%

echo .
echo .
echo Rights on %SCHEMA_TO_GRANT% have been granted to %ROLE_TO_CREATE%
echo .
popd