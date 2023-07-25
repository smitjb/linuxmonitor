@echo off
REM
REM $Header: /jbs/var/cvs/orascripts/bin/batch_audit_reports.bat,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
REM 
REM Wrapper script to call the main audit_reports script with parameters
REM
REM $Log: batch_audit_reports.bat,v $
REM Revision 1.1.1.1  2012/12/28 17:34:15  jim
REM First import
REM
REM Revision 1.1.1.1  2005/11/27 10:10:20  jim
REM Migrated from client sight
REM
REM Revision 1.2  2005/11/22 10:39:28  jim.smith
REM Fixed name of environment batch file (was setup_env)
REM
REM Revision 1.1  2005/08/24 14:19:30  jim.smith
REM removed pause from main script for batch running
REM added wrapper batch script to pass parameters
REM
REM 
REM ========================================================

audit_reports audit_reporter energis
