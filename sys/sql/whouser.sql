set pages 100
set lines 180

col orderby   form 9    noprint
col spid      form a7
col sid       form 999
col #serial   form a7
col os_user   form a10
col sess_user form a12
col terminal  form a15
col program   form a80

select '2'      orderby,
       p.spid  spid,
       s.sid,
       s.serial#,
       s.type   proc_type,
       DECODE (substr(UPPER(s.osuser),1,12)
              ,'N37618','Des  '
              ,substr(s.osuser,1,10)) OS_User,
       s.username sess_user,
       s.status,
       substr(s.machine,1,12) machine,
       s.terminal,
       substr(nvl(s.program, p.program),1,80) program
from   v$process p, v$session s
where  p.addr = s.paddr
and    s.username like UPPER('%&user%')
order by 1, 3, 5;


