declare
v_user_local  VARCHAR2(15);
v_user_remote VARCHAR2(15);
v_dblink      VARCHAR2(15);
begin
 v_user_local   := 'DEOWNERBS1';
 v_user_remote  := 'DEOWNERBS1';
 v_dblink       := 'TECCNG1.BP.COM';
 checkschemaDB (v_user_local, v_user_remote, v_dblink);
end;
/
