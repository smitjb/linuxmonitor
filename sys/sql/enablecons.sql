
#set linesize 180

spool enablem.sql
     SELECT 'ALTER TABLE ' || SUBSTR(b.table_name,1,30) || ' ENABLE CONSTRAINT ' || SUBSTR(b.constraint_name,1,30) || ';'
     FROM   user_constraints   a,
            user_cons_columns  b
     WHERE  a.constraint_name = b.constraint_name
     AND    a.owner           = b.owner
     AND    a.table_name      = b.table_name
     AND    a.status         != 'ENABLED'
     AND    a.constraint_type IN ('R','U','P')
     AND    a.constraint_name NOT LIKE 'SYS%'
     AND    b.constraint_name NOT LIKE 'SYS%';
spool off

PROMPT Now run @enablem.sql


