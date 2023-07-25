
declare
	sid number:=&1;
	serial number:=&2;
begin 

  sys.dbms_system.set_ev(sid,serial,10046,0,'');
--sys.dbms_system.set_sql_trace_in_session(sid,serial,false);

end;

/

