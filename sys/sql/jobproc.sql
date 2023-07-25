rem ---------------------------------------------------------------------------
rem Filename:   jobs.sql
rem Purpose:    returns information about jobs in the job queue
rem Author:     cdye@krinfo.com
rem Date:       31-Jul-1996
rem ---------------------------------------------------------------------------

column JOB              heading "Job"           format 9999
column LOG_USER         heading "User"          format a20
column LAST_DATE        heading "Last Date"     format a20
column NEXT_DATE        heading "Next Date"     format a20
column BROKEN           heading "B|r|o|k|e|n"   format a3
column INTERVAL         heading "Interval"      format a40
column FAILURES         heading "F|a|i|l"       format 99
column WHAT             heading "What"          format a66

PROMPT dba_jobs

SELECT  job,
        substr(log_user,1,20)                        log_user,
        to_char(last_date, 'DD-Mon-YYYY HH24:mi:ss') last_date,
        to_char(next_date, 'DD-Mon-YYYY HH24:mi:ss') next_date,
        decode(broken, 'Y', 'Yes', 'No')             broken,
        SUBSTR(interval,1,50)                        interval,
        failures,
        what
FROM    dba_jobs
ORDER BY 2,5
/

PROMPT Wots going on in DBA_JOBS_RUNNING ?

-- select * from dba_jobs_running;
-- !date

