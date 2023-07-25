DECLARE user_to_copy_from VARCHAR2(30) := 'MIOWNER';
user_to_copy_to VARCHAR2(30) := 'MIOWNER2';
granted_schema VARCHAR2(30);
granted_object VARCHAR2(30);
granted_privilege VARCHAR2(30);

CURSOR grants IS
SELECT owner,
  TABLE_NAME,
  privilege
FROM dba_tab_privs
WHERE grantee = UPPER(user_to_copy_from);

grant_row grants % rowtype;

BEGIN

  FOR x IN grants
  LOOP
    EXECUTE IMMEDIATE 'grant ' || x.privilege || ' ON ' || x.owner || '.' || x.TABLE_NAME || ' to ' || user_to_copy_to;
  END LOOP;

END;
