@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/settlecalgap.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM Script to run the add_settlement_calendar_exception sql script
REM 
REM Usage
REM settlecalgap username password runnumber
REM
REM 
REM $Log: settlecalgap.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.4  2005/11/18 10:36:29  jim.smith
REM Fixed typo in parameter name
REM
REM Revision 1.3  2005/09/21 09:39:03  jim.smith
REM Fixed pushd/popd usage error
REM
REM Revision 1.2  2005/07/27 13:47:16  jim.smith
REM Fixed name of sql script
REM added echo of name and version
REM
REM Revision 1.1  2005/07/27 12:04:54  jim.smith
REM New batch files to run p99 supplementary sql utilities
REM
REM 
REM ========================================================
echo settlcalgap.bat $Revision: 1.1.1.1 $
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
if "%3" == "" goto nodate
set settlementrun=%3
goto main
:nouser
set /p user=Username?
:nopass
set /p pass=Password?
:nodate
set /p  settlementrun=Missing settlement run?
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
echo %settlementrun%


echo sqlplus %user%/%pass%%database% @add_settlement_cal_exception.sql %settlementrun%

echo -========== ENDDEBUG

:nodebug

sqlplus %user%/%pass%%database% @add_settlement_cal_exception.sql %settlementrun%

set pass=
set user=
set settlementrun=
set SQLPATH=%TEMPSQLPATH%
popd
:end
pause