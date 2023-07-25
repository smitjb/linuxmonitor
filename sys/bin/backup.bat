@echo off
rem 
rem $Header: /jbs/var/cvs/orascripts/bin/backup.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
rem 
rem $Log: backup.bat,v $
rem Revision 1.1.1.1  2012/12/28 17:34:15  jim
rem First import
rem
rem Revision 1.1.1.1  2005/11/27 10:10:20  jim
rem Migrated from client sight
rem
rem Revision 1.2  2005/11/15 14:28:55  jim.smith
rem added some comments and checking
rem
rem Revision 1.1  2005/11/15 14:17:36  jim.smith
rem First checked in version
rem
rem 
rem ==================================================================

set BACKUPLOGDIR=I:\BACKUPS\

if "%LOCAL%" == "" GOTO NODB

SET BACKUPFILENAME=%BACKUPLOGDIR%BACKUP_%LOCAL%.LOG

echo ================================================================================ >%BACKUPFILENAME%
echo "Backup up database %LOCAL%" >>%BACKUPFILENAME%
echo ================================================================================ >>%BACKUPFILENAME%

goto MAIN
:nodb

SET BACKUPFILENAME=%BACKUPLOGDIR%BACKUP_DEFAULT.LOG 

echo ================================================================================ >%BACKUPFILENAME%
echo "WARNING: LOCAL not set. Backing up default database(if any)." >>%BACKUPFILENAME%
echo ================================================================================ >>%BACKUPFILENAME%
 

:main

REM
REM set the date format here so that rman displays useful time stamps
REM
set NLS_DATE_FORMAT=DD-Mon-YYYY HH24:MI:SS

echo ================================================================================ >>%BACKUPFILENAME%
echo "Starting..." >>%BACKUPFILENAME%
echo ================================================================================ >>%BACKUPFILENAME%
date /T >>%BACKUPFILENAME%
time /T >>%BACKUPFILENAME%

rman @%ELX_BINDIR%\backup.rman >>%BACKUPFILENAME%

date /T >>%BACKUPFILENAME%
time /T >>%BACKUPFILENAME%
echo ================================================================================ >>%BACKUPFILENAME%
echo "Finished..." >>%BACKUPFILENAME%
echo ================================================================================ >>%BACKUPFILENAME%

