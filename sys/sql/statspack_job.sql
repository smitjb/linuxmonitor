declare
jid number;
begin
  dbms_job.submit(job=>jid, what=>'statspack.snap(5);',next_date=>sysdate+(1/96),interval=>'sysdate+(1/96)');
end;
/
