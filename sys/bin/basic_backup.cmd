@echo off
setlocal
set PATH=D:\cygwin\bin;%PATH%

set WORKDIR=%~pd0%
rem set WORKDRIVE=%~d0%

pushd %WORKDRIVE%%WORKDIR%
rem pwd
rem cd
rem echo !%WORKDRIVE%!%WORKDIR%!

bash basic_backup.ksh %*

popd
endlocal
