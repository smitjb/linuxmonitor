
setlocal
set CONNECT_STRING=%1
set USERNAME=%2
set PASSWORD=%3


set JDBCJAR=c:\oracle\product\10.2.0\client_1\jdbc\lib\ojdbc14.jar
set APEXDIR=e:\downloads\apex_3.2.1\apex
e:
cd %APEXDIR%\utilities
set CP=%JDBCJAR%;.

rem Not supported in apex 3
rem java -cp %CP% oracle.apex.APEXExport -db %CONNECT_STRING% -user %USERNAME% -password %PASSWORD% -expworkspace
rem 
java -cp %CP% oracle.apex.APEXExport -db %CONNECT_STRING% -user %USERNAME% -password %PASSWORD% -instance
endlocal