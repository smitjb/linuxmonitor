

set feedback off
set heading  off

spool validatem.sql

select 'CONN ' || user || '/' || user
from   dual;

select substr(object_type,1,15) object_type,
       substr(object_name,1,30) object_name,
       status
from   user_objects
where  status = 'INVALID'
OR     status = 'DISABLED'
order by 2,1;

SELECT 'ALTER TABLE ' || RPAD(b.table_name,30,' ') || ' ENABLE CONSTRAINT ' || SUBSTR(b.constraint_name,1,30) || ';'
FROM   user_constraints   a,
       user_cons_columns  b
WHERE  a.constraint_name = b.constraint_name
AND    a.owner           = b.owner
AND    a.table_name      = b.table_name
AND    a.constraint_type IN ('R','U','P')
AND    a.status != 'ENABLED'
ORDER BY a.constraint_type,
         b.table_name;

SELECT 'ALTER TRIGGER ' || trigger_name || ' COMPILE;'
FROM   user_triggers
WHERE  status != 'ENABLED';

SELECT 'ALTER TRIGGER ' || trigger_name || ' ENABLE;'
FROM   user_triggers
WHERE  status != 'ENABLED';

spool off

set feedback on
set heading  on

PROMPT .
PROMPT Now run @validatem.sql



