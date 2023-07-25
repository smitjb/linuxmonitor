@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/create_dba_user.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM
REM $Log: create_dba_user.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.3  2005/11/02 10:12:41  jim.smith
REM Added as sysdba to allow granting of sysdba
REM
REM Revision 1.2  2005/09/21 09:16:35  jim.smith
REM Added standard environment and command line processing
REM
REM Revision 1.1  2005/08/15 13:04:07  jim.smith
REM Added better environment handling
REM Created separate batch files for different user types
REM
REM
REM =====================================================================

echo create_dba_user.bat $Revision: 1.1.1.1 $
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
if "%3" == "" goto nonewuser
set newuser=%3
goto main
:nouser
set /p user=Username?
:nopass
set /p pass=Password?
:nonewuser
set /p  newuser=User to create?
:main

set PASSWORD=elex0n
sqlplus "%user%/%pass% as sysdba"  @%ELX_SQLDIR%\create_dba_user %newuser% %PASSWORD%

echo .
echo .
echo User %newuser% has been created with a temporary password of %PASSWORD%
echo .

set user=
set pass=
set newuser=
set PASSWORD=
set SQLPATH=%TEMPSQLPATH%
popd
REM _EOF