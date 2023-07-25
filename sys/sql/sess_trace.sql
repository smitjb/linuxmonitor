
declare
	sid number:=&1;
	serial number:=&2;
begin 

 dbms_system.set_bool_param_in_session(sid,serial,'timed_statistics',true);
 dbms_system.set_int_param_in_session(sid,serial,'max_dump_file_size',2147483647);
 dbms_system.set_sql_trace_in_session(sid,serial,true);

end;

/
