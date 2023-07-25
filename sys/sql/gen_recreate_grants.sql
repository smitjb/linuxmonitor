--
-- gen_recreate_grants.sql
--
-- script to generate a script to recreate the grants for a user
--
SELECT 'GRANT '||
	PRIVILEGE||
	' ON '||
	OWNER||
	'.'||
	TABLE_NAME||
	' TO ' ||
	GRANTEE ||
	';'
FROM dba_tab_privs where grantee='&grantee';
