

      SPOOL temp.lis

      SELECT 'CREATE USER ' || username || ' IDENTIFIED BY ' || username ||
             ' DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;' || CHR(10) ||
             'GRANT connect, resource, olf_user TO ' || username || ';'
      FROM   OLOWNERBS1.bu_ng_save_password
      WHERE NOT EXISTS (
             SELECT alu.username
             FROM all_users alu where bu_ng_save_password.username = alu.username)
      ORDER BY username;

      SELECT 'ALTER USER ' || username || ' IDENTIFIED BY VALUES ''' || password || ''';'
      FROM   OLOWNERBS1.bu_ng_save_password
      ORDER BY username;

      SPOOL OFF

      PROMPT .
      PROMPT Now run @temp.lis
      PROMPT .
