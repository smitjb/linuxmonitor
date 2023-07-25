---
--- needs to be run as FLOWS_xxxxxx user.
begin
wwv_flow_api.set_security_group_id(p_security_group_id=>10);

wwv_flow_fnd_user_api.create_fnd_user(
p_user_name => 'admin2',
p_email_address => 'jim.smith@pias.com',
p_web_password => 'plastron') ;

end;
/
