SELECT asbr_batch_start_time,
  SUM(st.asjr_result_value)  ,
  SUM(en.asjr_result_value),
  count(*),
    SUM(st.asjr_result_value)-  SUM(en.asjr_result_value)
   FROM app_support_batch_runs
   inner join   app_support_job_result st on    asbr_id              = st.asjr_asbr_id
   inner join   app_support_job_result en on asbr_id              = en.asjr_asbr_id
  WHERE en.asjr_result_type='END_SIZE'
  AND st.asjr_result_type  ='START_SIZE'
 GROUP BY asbr_batch_start_time
ORDER BY app_support_batch_runs.asbr_batch_start_time desc;

