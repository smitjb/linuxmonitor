@echo off
@REM
@REM $Header: /jbs/var/cvs/orascripts/bin/topandtail.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
@REM
@REM 
@REM $Log: topandtail.bat,v $
@REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
@REM First import
@REM
@REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
@REM Migrated from client sight
@REM
@REM
@REM
@REM =======================================================================
if "%1" == "" goto usage
copy %1 %1.bak
echo create or replace >%1.tmp
type %1 >>%1.tmp
echo / >> %1.tmp
del %1
ren %1.tmp %1
goto end
:usage
echo topandtail: add pl/sql header and footer to files
echo usage - "topandtail <filename>"
:end
