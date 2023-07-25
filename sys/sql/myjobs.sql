
alter session set nls_date_format='dd-Mon-yyyy hh24:mi:ss';
set linesize 200
col task newline heading ""
select job,
       sysdate,
       last_date,
       this_date,
       next_date,
       broken,
	failures,
	substr(what,1,190) task
from user_jobs

/
	