@echo off
if "%DEBUG%" == "" goto nodebug
echo =========== DEBUG setupenv
echo %~0
echo %~f0
echo %~d0
echo %~p0
echo %~n0
echo %~x0
echo %~s0
echo %~ps0
echo ============= Current environment
set
echo ============= Current environment
echo =========== DEBUG setupenv

:nodebug

REM 
REM  1 Where am I?
REM  

set DRIVE=%~d0
set DIR=%~p0

set CP=%DRIVE%%DIR%keymanager.jar


if "%DEBUG%" == "" goto nodebug2
echo =========== DEBUG command line
echo java -cp %CP% com.chrysaetos.apps.keyring.KeyRing %1 %2 %3 %4 %5 %6 %7 %8 %9
cd
echo =========== DEBUG debug command line
:nodebug2
java -cp %CP% com.chrysaetos.apps.keyring.KeyRing %1 %2 %3 %4 %5 %6 %7 %8 %9


if "%DEBUG%" == "" goto nodebug2
echo =========== DEBUG setupenv
echo ============= New environment
set
echo ============= New environment
echo =========== DEBUG setupenv

:nodebug2

:end