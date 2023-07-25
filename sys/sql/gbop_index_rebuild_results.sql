select asbr_batch_name, asbr_component_name, app_support_batch_runs.asbr_component_start_time, t.asjr_result_value, s.asjr_result_value,e.asjr_result_value, s.asjr_result_value-e.asjr_result_value gain 
from app_support_batch_runs
inner join app_support_job_result t
on asbr_id=t.asjr_asbr_id
inner join app_support_job_result s
on asbr_id=s.asjr_asbr_id
inner join app_support_job_result e
on asbr_id=e.asjr_asbr_id
where asbr_component_start_time > '11-oct-2000'
and t.asjr_result_type='ELAPSED_TIME'
AND s.asjr_result_type='START_SIZE'
AND e.asjr_result_type='END_SIZE'
order by asbr_component_start_time, asbr_component_name, asjr_result_type;

