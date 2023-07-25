@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/shutdown_parms.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM $Log: shutdown_parms.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.1  2005/11/15 13:44:38  jim.smith
REM First checked in version
REM
REM 
REM ========================================================
set DRIVE=C:
set DIR=\Program Files\PARMS\Data Receipt and Despatch

if "%1" == "" then goto NOPARMS
set DRIVE=%1 
set DIR=%2

:NOPARMS
pushd
%DRIVE%
cd %DIR%
CD
echo =========================================================
echo Shutting down PARMS in %DRIVE%%DIR%
echo This may produce "Connection refused" errors if the
echo relevant processes are not running. These can be ignored
echo =========================================================
echo *************************  Data File Parser ************
cd "Data File Parser\bin"
call shutdown
cd ..\..
echo *************************  Data File Sorter ************
cd "Data File Sorter\bin"
call shutdown
cd ..\..
echo *************************  Email Despatch **************
cd "Email Despatch\bin"
call shutdown
cd ..\..
echo *************************  Email Receipt ***************
cd "Email Receipt\bin"
call shutdown
cd ..\..
popd
echo =========================================================
echo Finished
echo =========================================================
