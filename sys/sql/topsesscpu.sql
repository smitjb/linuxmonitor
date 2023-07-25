select 	nvl(ss.USERNAME,'ORACLE PROC') username,
	se.SID,
	VALUE cpu_usage
from 	v$session ss,
	v$sesstat se,
	v$statname sn
where  	se.STATISTIC# = sn.STATISTIC#
and  	NAME like '%CPU used by this session%'
and  	se.SID = ss.SID
order  	by VALUE desc
/
