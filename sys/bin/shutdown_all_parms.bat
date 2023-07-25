@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/shutdown_all_parms.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM $Log: shutdown_all_parms.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.1  2005/11/15 14:34:41  jim.smith
REM First checked in version
REM
REM 
REM ========================================================

cd
echo Shutting down PPT environment
call shutdown_parms C: "\Program Files\PARMS\Data Receipt and Despatch"
f:
echo Shutting down Parallel environment
call shutdown_parms E: "\PARMS\Data Receipt and Despatch"


