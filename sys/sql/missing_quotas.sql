select u.username,u.default_tablespace from dba_users u
where (u.username,u.default_tablespace) not in ( select q.username,q.tablespace_name
from dba_ts_quotas q)