set pages 100
set lines 180

col orderby   form 9    noprint
col spid      form a7
col sid       form 999
col #serial   form a7
col os_user   form a10
col sess_user form a12
col terminal  form a15
col program   form a40
col machine   form a20


SELECT   substr(r.name,1,10)          "RB NAME ", 
         p.pid                        "ORACLE PID",
         p.spid                       "SYSTEM PID ", 
      -- s.type                       proc_type,
      -- NVL (p.username, 'NO TRANSACTION'), 
         DECODE (substr(UPPER(s.osuser),1,12)
              ,'N37618','Des  '
              ,substr(s.osuser,1,10)) OS_User,
         s.username                   sess_user,
         s.machine                    machine,
         nvl(s.program, p.program)    program,
       --substr(s.username||'('||l.sid||')',1,20)   "Session" ,
         p.terminal
FROM     v$lock      l, 
         v$process   p, 
         v$rollname  r,
         v$session   s
WHERE    l.sid = p.pid(+)
AND      p.addr = s.paddr
AND      TRUNC (l.id1(+)/65536) = r.usn
AND      l.type(+) = 'TX'
AND      l.lmode(+) = 6
ORDER BY r.name;
