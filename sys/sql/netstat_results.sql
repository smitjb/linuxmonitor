select state,count(*) from netstat_results group by state;

select substr(remote,1,length(remote)-instr(remote,'.',4)-1),state,count(*)
from netstat_results
group by substr(remote,1,length(remote)-instr(remote,'.',4)-1),state
order by 1,2;

create table netstat_results_bak as select * from netstat_results;