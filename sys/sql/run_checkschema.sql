declare
v_user_local  VARCHAR2(15);
v_user_remote VARCHAR2(15);
v_dblink      VARCHAR2(15);
begin
 v_user_local   := 'RDOWNERBS1';
 v_user_remote  := 'DEOWNERBS2';
 v_dblink       := 'DEVLDE2.BP.COM';
 checkschema (v_user_local, v_user_remote);
end;
/
