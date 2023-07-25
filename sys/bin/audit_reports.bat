@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/audit_reports.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM Script to run the audit report.
REM
REM Depends on Windows Command extensions being enabled.
REM 
REM Usage
REM audit_reports username password 
REM 
REM If parameters are omitted they will be prompted for.
REM Only trailing parameters can be omitted.
REM 
REM $Log: audit_reports.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.6  2005/11/22 10:39:16  jim.smith
REM Changed auditing password
REM
REM Revision 1.5  2005/09/21 09:37:33  jim.smith
REM Fixed pushd/popd usage error
REM
REM Revision 1.4  2005/08/24 14:19:30  jim.smith
REM removed pause from main script for batch running
REM added wrapper batch script to pass parameters
REM
REM Revision 1.3  2005/08/22 09:45:42  jim.smith
REM Changed name of environment batchfile to setup_env
REM
REM Revision 1.2  2005/08/22 09:33:45  jim.smith
REM Added log directory as parameter to sql scripts
REM
REM Revision 1.1  2005/08/19 15:56:09  jim.smith
REM First version
REM
REM 
REM ========================================================
echo audit_reports.bat $Revision: 1.1.1.1 $
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
goto main
:nouser
set /p user=Username?
:nopass
set /p pass=Password?
:main


if "%DEBUG%"=="" goto  nodebug
echo =========== DEBUG 
cd 

echo %~0
echo %~f0
echo %~d0
echo %~p0
echo %~n0
echo %~x0
echo %~s0
echo %~sp0

rem echo %~t0
rem echo %~z0


echo %ELX_ROOTDIR%
echo %ELX_TMPDIR%
echo %ELX_SQLDIR%
echo %ELX_BINDIR%
echo %ELX_LOGDIR%
echo %ELX_CFGDIR%
echo %SQLPATH%
echo %user%
echo %pass%
echo %perioddate%



echo -========== ENDDEBUG

:nodebug

sqlplus %user%/%pass%%database% @audit_logins.sql %ELX_LOGDIR%
sqlplus %user%/%pass%%database% @audit_parms_usage.sql %ELX_LOGDIR%

set pass=
set user=
set database=
set SQLPATH=%TEMPSQLPATH%

popd
:end
