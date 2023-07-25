--
-- Generic stored procedure thta recompiles any invalid user objects
-- &1=spool filename
-- &2=Schema owner
-- loops around 5 times in order to ensure we recompile depenedent objects     
--
-- History
--
-- Who		 When		What
-- Daniel Simons 04/12/2006	Created	 

spool &1
set serverout on
whenever sqlerror exit failure
alter session set current_schema=&&2;

prompt recompiling invalid user objects

DECLARE

        ownname varchar2(30) := '&&2';
        FailCount PLS_INTEGER := 0;
        SQLTxt VARCHAR2 (2000);
        failedProcs VARCHAR2 (2000) := ' ';

        CURSOR csr_exe IS
        SELECT  object_name,DECODE (object_type,'PACKAGE BODY','PACKAGE',object_type) object_type
        FROM all_objects
        WHERE status = 'INVALID'
        AND owner LIKE ownname
        AND object_type IN  ('PACKAGE BODY','PACKAGE','PROCEDURE','FUNCTION','TRIGGER','VIEW');

        proc all_objects.object_name%type;

BEGIN

        dbms_output.enable(1000000);

       	dbms_output.put_line ('Checking for invalid objects in the '||ownname||' schema'); 

        Failcount := 0;

        FOR i IN 1..5 LOOP
           FOR rec_exe IN csr_exe LOOP
                BEGIN
                    proc:=rec_exe.OBJECT_NAME;
                    dbms_output.put_line('Recompiling '||RTRIM(rec_exe.object_type)||' '||proc);
                    SQLtxt := 'ALTER '||RTRIM(rec_exe.object_type)||' '||ownname||'.'||proc||' compile';


                    EXECUTE IMMEDIATE SQLtxt;
                    --If we get here compilation was a success
                    dbms_output.put_line(rec_exe.OBJECT_NAME||' Success!');

                    --If it had previously failed indicate it has now compiled
                    FOR rec IN (select 1 from dual where failedProcs like '%'||proc||'%')
                    LOOP
                        select replace(failedProcs,proc,'') into failedProcs from dual;
                        Failcount:=Failcount-1;
                    END LOOP;

                EXCEPTION
                WHEN OTHERS THEN
                        dbms_output.put_line('** FAILED **'||failedProcs);

                        -- if it is not already known as a failure
                        FOR note in (select 1 from dual where failedProcs not like '%'||proc||'%')
                        LOOP
                                FOR rec IN (select sequence,line,position,text from dba_errors
                                            where owner=ownname and name=proc
                                            order by sequence)
                                LOOP
                                        dbms_output.put_line('line: '||rec.line||' Err: '||rec.text);

                                END LOOP;
                                failedProcs:=failedProcs||' '||proc;
                                Failcount:= Failcount+1;
                        END LOOP;
                        dbms_output.put_line('Failures='||Failcount);
                END;
           END LOOP;
        END LOOP;

        if Failcount > 0 then
                raise_application_error(-20001,'Error there were '||Failcount||' Compilation errors - '||failedProcs);
        end if;
        -- Compile the last one (depends on others)
exception
when others then
        raise_application_error(-20002,'Error: '||sqlerrm(sqlcode));
END;
/
spool off
