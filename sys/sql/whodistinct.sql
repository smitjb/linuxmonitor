set pages 100
set lines 180

col orderby   form 9    noprint
col spid      form a7
col sid       form 999
col #serial   form a7
col os_user   form a10
col sess_user form a15
col terminal  form a15
col program   form a80

select distinct(s.username) sess_user,
       count(*)
from   v$process p, 
       v$session s
where  p.addr = s.paddr
group by s.username
order by 2,1 desc;


