@echo off
REM.-- Prepare the Command Processor --
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
 
::: -- Set the window title --
set title=Running the selected script in Sql*Plus...
TITLE %title%
 
::: Parameters are
::: %1 is the username
::: %2 is the password
::: %3 is the connection string in EasyConnect SQLDeveloper format
::: %4 is the script file name with fully qualified path
echo.
set dbuser=%1
set dbpwd=%2
set dbconn=%3
set sqlscript=%4
 
echo.
for /f "tokens=1,2,3 delims=: " %%a in ("%dbconn%") do set server=%%a&set port=%%b&set sid=%%c
echo.DB Server: %server%
echo.DB Port  : %port%
echo.DB SID   : %sid%
 
echo.
echo.Executing script...
sqlplus -S -L %dbuser%/%dbpwd%@%server%:%port%/%sid% @%sqlscript%
 
echo.Script execution terminated.

