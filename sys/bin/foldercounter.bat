@echo off
@REM 
@REM $Header: /jbs/var/cvs/homeutils/bin/foldercounter.bat,v 1.1 2013/01/04 10:25:22 jim Exp $
@REM 
@REM 
@REM $Log: foldercounter.bat,v $
@REM Revision 1.1  2013/01/04 10:25:22  jim
@REM Migrated from utils
@REM
@REM Revision 1.1  2012/05/22 07:55:14  jim
@REM First checkin after import
@REM
@REM 
@REM 
@REM 
@REM ===================================================================

set JAVA_HOME=C:\progs\jdk1.5.0_03

set LOGDIR=c:\var\logs
set LIBDIR=..\lib
set CP=%LIBDIR%\foldercounter.jar
set CP=%CP%;%LIBDIR%\activation.jar
set CP=%CP%;%LIBDIR%\mail.jar
set CP=%CP%;%LIBDIR%\ojdbc14.jar

%JAVA_HOME%\bin\java -cp %CP% com.chrysaetos.mailtools.IMAPFolderCounter >%LOGDIR%\foldercounter.log 2>&1

REM _EOF
