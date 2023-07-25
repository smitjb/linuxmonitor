break on report 
compute sum of sessions on report
select username,
       machine,
	COUNT(*) sessions
from v$session
where type <> 'BACKGROUND'
GROUP BY USERNAME,MACHINE
/
