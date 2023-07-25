declare 
 jobid number;

begin
	dbms_job.submit(jobid,'dbms_stats.gather_schema_stats(''PARMS'',null,false,''for all columns'',null,''default'',true);',trunc(sysdate+1),'sysdate +7');

end;

/
