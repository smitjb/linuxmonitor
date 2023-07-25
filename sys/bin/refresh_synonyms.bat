@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/refresh_synonyms.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM $Log: refresh_synonyms.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.3  2005/09/22 09:35:49  jim.smith
REM Dropped second parameter in call to sql script and corrected typo in name of first parmaeter
REM
REM Revision 1.2  2005/09/21 09:16:35  jim.smith
REM Added standard environment and command line processing
REM
REM 
REM ========================================================

echo refresh_synonyms.bat $Revision: 1.1.1.1 $
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

sqlplus %user%/%pass% @%ELX_SQLDIR%\refresh_synonyms  %ELX_TMPDIR%  

popd