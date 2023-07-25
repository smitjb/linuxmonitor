col what newline
select job,log_user, last_date,this_date,next_date, failures,broken, substr(what,1,70) what
from dba_jobs
where nvl('&1',job)=job
/
