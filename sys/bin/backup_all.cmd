@echo off
setlocal
set PATH=D:\cygwin\bin;d:\progs\utils\bin;%PATH%

set WORKDIR=%~pd0%
rem set WORKDRIVE=%~d0%

pushd %WORKDRIVE%%WORKDIR%
rem pwd
rem cd
rem echo !%WORKDRIVE%!%WORKDIR%!

bash backup_all.ksh %*

popd
endlocal
rem pause