set serveroutput on
define usr  =&1
define tries=&2 

DECLARE
  v_sid    NUMBER(12);
  v_serial NUMBER(13);
  v_try    NUMBER(2)   :=&tries;
  v_user   VARCHAR2(30):='&usr';
  cmd varchar2(100);
BEGIN
  dbms_output.enable;
  dbms_output.put_line('Killing sessions for user '||v_user);
  FOR try IN 1..v_try
  LOOP
    dbms_output.put_line('Loop '||try);
    BEGIN
      FOR sess IN (       SELECT * FROM v$session WHERE username=upper(v_user))
      LOOP
        v_sid                                                             :=sess.sid;
        v_serial                                                          :=sess.serial#;
        dbms_output.put_line('Killing session '||v_sid||'-'||v_serial);
        cmd:='alter system kill session '''||v_sid||','||v_serial||'''';
        EXECUTE immediate cmd;
      END LOOP;
    EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('No more sessions. Exiting');
      EXIT 
        ;
      WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
        NULL;
        -- ignore kill errors
      END;
    END LOOP;
end;

/
