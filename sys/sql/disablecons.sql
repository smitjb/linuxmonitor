SPOOL disablem.sql

     SELECT 'ALTER TABLE ' || SUBSTR(b.table_name,1,30) || ' DISABLE CONSTRAINT ' || SUBSTR(b.constraint_name,1,30) || ';'
     FROM   user_constraints   a,
            user_cons_columns  b
     WHERE  a.constraint_name = b.constraint_name
     AND    a.owner           = b.owner
     AND    a.table_name      = b.table_name
     AND   (a.constraint_type = 'R'
            OR
            a.constraint_type = 'P' 
            OR
            a.constraint_type = 'U')
     AND    a.constraint_name NOT LIKE 'SYS%'
     AND    b.constraint_name NOT LIKE 'SYS%';
--   AND    a.table_name IN ('RDUSB_SCUSR_RDBCH',
--                           'RDUSC_USER_BP_COMPANIES',
--                           'RDREG_REGIONS')

SPOOL OFF
PROMPT Now run @disablem.sql
