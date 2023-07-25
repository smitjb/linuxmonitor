@echo off
rem  Deimp.exe v0.1 Copyright (C) 2008 Nick Rapallo, nrapallo@yahoo.ca
echo Deimp process devised by Nick Rapallo (May. 2008)
echo =================================================
echo prepare .imp files to extract text
echo (this recursively goes down into sub-dirs)...
dir "*.imp" /s /b > _NRimplist.txt
for /f "tokens=*" %%a in (_NRimplist.txt) do unimp.exe "%%a"
echo.

echo extract and decompress text from exploded .imp files...
dir "*.RES" /s /b > _NRreslist.txt
for /f "tokens=*" %%a in (_NRreslist.txt) do deimp.exe -i "%%a\Data.frk" -o "%%a.txt"
echo Decompressed file ends with '.RESdirname.txt'
echo.

rem remove below rem if need '.orig.txt' copy
rem for /f "tokens=*" %%a in (_NRreslist.txt) do copy "%%a\Data.frk" "%%a.orig.txt" >nul
echo Otherwise, if file was not compressed initially,
echo check file ending with '.orig.txt' (see .bat file for details)
echo.

echo remove exploded .imp (.RES) directories...
for /f "tokens=*" %%a in (_NRreslist.txt) do del "%%a\*.*" /q
for /f "tokens=*" %%a in (_NRreslist.txt) do rmdir "%%a" /q
echo Done!
pause