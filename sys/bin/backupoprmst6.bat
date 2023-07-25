@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/backupoprmst6.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM $Log: backupoprmst6.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.2  2005/11/22 10:38:20  jim.smith
REM Fixed name of environment batch file (was setup_env)
REM
REM Revision 1.1  2005/11/15 14:34:41  jim.smith
REM First checked in version
REM
REM 
REM ========================================================
echo backupoprmst6.bat $Revision: 1.1.1.1 $
echo .
pushd
set TEMPSQLPATH=%SQLPATH%
set WORKINGDRIVE=%~d0
set WORKINGDIR=%~p0

%WORKINGDRIVE%
cd %WORKINGDIR%

call ..\etc\setupenv

set LOCAL=OPRMST6
CALL BACKUP
SET LOCAL=
set SQLPATH=%TEMPSQLPATH%
