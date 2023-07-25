break on report
compute sum of sesscount on report
select username,count(*) sesscount
from v$session group by username;