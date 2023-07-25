@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/startup_parms.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM $Log: startup_parms.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.2  2005/11/15 13:54:12  jim.smith
REM Changed order of startup to follow Logica recommendations
REM
REM Revision 1.1  2005/11/15 13:46:58  jim.smith
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
echo Starting PARMS in %DRIVE%%DIR%
echo =========================================================
echo *************************  Email Despatch **************
cd "Email Despatch\bin"
start emaildespatch.bat
cd ..\..
echo *************************  Data File Parser ************
cd "Data File Parser\bin"
start DataFileParser.bat
cd ..\..
echo *************************  Data File Sorter ************
cd "Data File Sorter\bin"
start DatafileSorter.bat
cd ..\..
echo *************************  Email Receipt ***************
cd "Email Receipt\bin"
start "email receipt".bat
cd ..\..
popd
echo =========================================================
echo Finished
echo =========================================================
