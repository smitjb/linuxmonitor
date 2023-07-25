set linesize 119
col kill_id format a12 hea "ID for|KILL SESSION"
col username format a14 hea "Oracle|user"
col osuser format a8 hea "OS|user"
col used_ublk format 999990 hea "Undo|blocks"
col used_u_mb format 9,990.0 hea "Undo MB"
col used_urec format 999990 hea "Undo|records"
col session_status format a8 hea "Session|status"
col logged_on_for  format a11 hea "Logged on|for"
col logon_time hea "Session|started"
col transaction_status format a8 hea "Transaction|status"
col transaction_start format a11 hea "Transaction|started"
col type hea "Session|type"
col command format a20 trunc hea "Command"
col redo format a10 hea "      Redo"

break on report
comp sum label "" of used_u_mb redo_m on report

SELECT --+ ALL_ROWS
       '''' || s.sid || ', ' || s.serial# || '''' kill_id
     , s.osuser
     , s.username
     , REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
       ( TO_CHAR(TRUNC(SYSDATE,'MONTH') + (SYSDATE - s.logon_time), 'DD HH24:MI:SS')
       , '01 ', '00 '), '02 ', '01 '),'03 ','02 '),'04 ','03 '),'05 ','04 ') AS logged_on_for
     , s.status AS session_status
     , t.status AS transaction_status
     , TO_CHAR(TO_DATE(t.start_time,'MM/DD/RR HH24:MI:SS'),'HH24:MI:SS') AS transaction_start
     , (t.used_ublk * db.block_size)/1048576 used_u_mb
     , CASE
       WHEN sstat.value = 0 OR sstat.value IS NULL
            THEN TO_CHAR(NULL)
       WHEN sstat.value < 1048576
            THEN LPAD(TO_CHAR(GREATEST(sstat.value/1024,1),'999G999') || ' K',10)
       WHEN sstat.value < 1073741824
            THEN LPAD(TO_CHAR(sstat.value/1048576,'999G999') || ' M',10)
       ELSE
            LPAD(TO_CHAR(sstat.value/1073741824,'999G999') || ' G',10)
       END AS redo
     , CASE
       WHEN a.name = 'UNKNOWN'
            THEN NULL
       WHEN a.name IS NOT NULL
            THEN a.name
       WHEN s.command = -67
            THEN 'MERGE'
       ELSE
            TO_CHAR(s.command)
       END AS command
FROM   ( SELECT value AS block_size
         FROM   v$parameter
         WHERE  name = 'db_block_size' ) db
     , v$session s
     , audit_actions a
     , v$transaction t
     , v$sesstat sstat
     , v$statname n
WHERE  s.username IS NOT NULL
AND    s.audsid != SYS_CONTEXT('USERENV','SESSIONID')  -- Exclude this session
AND    a.action (+)= s.command
AND    t.addr (+)= s.taddr
AND    sstat.sid (+)= s.sid
AND    n.statistic# = sstat.statistic#
AND    n.name = 'redo size'
ORDER BY s.logon_time, TO_DATE(t.start_time,'MM/DD/RR HH24:MI:SS')
/
