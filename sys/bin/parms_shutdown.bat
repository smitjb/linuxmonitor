@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/parms_shutdown.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM $Log: parms_shutdown.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.1  2005/08/11 14:58:29  jim.smith
REM Migrated from utils project
REM
REM 
REM ========================================================
set DRIVE=C:
set DIR=\Program Files\PARMS\Data Receipt and Despatch

%DRIVE%
cd %DIR%
CD
echo Shutting down PARMS in %DRIVE%%DIR%
echo Email Despatch
cd "Email Despatch\bin"
call shutdown
cd ..\..
echo Email Receipt
cd "Email Receipt\bin"
call shutdown
cd ..\..
echo Data File Parser
cd "Data File Parser\bin"
call shutdown
cd ..\..
echo Data File Sorter
cd "Data File Sorter\bin"
call shutdown
cd ..\..
echo Finished
