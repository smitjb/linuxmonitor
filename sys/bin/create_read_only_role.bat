@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/create_read_only_role.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM Create a role with read access to a named schema
REM 
REM usage 
REM create_read_only_role dbuser dbpassword newrole schema
REM
REM $Log: create_read_only_role.bat,v $
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
REM Revision 1.1  2005/05/26 09:49:53  jim.smith
REM First tested version
REM
REM
REM
REM =====================================================================
echo create_read_only_role.bat $Revision: 1.1.1.1 $
echo .

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
if "%4" == "" goto noschema
set SCHEMA_TO_GRANT=%4
goto main
:nouser
set /p user=Username?
:nopass
set /p pass=Password?
:norole
set /p  role_to_create=Role to create?
:noschema
set /p  schema_to_grant=Schema to grant?


:main

sqlplus %user%/%password% @%ELX_SQLDIR%\create_read_only_role %ELX_SQLDIR% %ELX_TMPDIR% %ROLE_TO_CREATE% %SCHEMA_TO_GRANT%

echo .
echo .
echo Role %ROLE_TO_CREATE% has been created with read access to %SCHEMA_TO_GRANT% 
echo .
popd