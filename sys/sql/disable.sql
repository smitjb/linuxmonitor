SET LINESIZE 160
SET PAGES    0
SET FEEDBACK OFF

SPOOL temp.lis

SELECT 'ALTER TABLE ' || RPAD(b.table_name,30,' ') || 
       ' DISABLE CONSTRAINT ' || SUBSTR(b.constraint_name,1,30) || ';'
FROM   user_constraints   a,
       user_cons_columns  b
WHERE  a.constraint_name = b.constraint_name
AND    a.owner           = b.owner
AND    a.table_name      = b.table_name
AND    a.constraint_type = 'R'
AND    a.constraint_name NOT LIKE 'SYS%'
AND    b.constraint_name NOT LIKE 'SYS%'
ORDER BY b.table_name;

SPOOL OFF

@temp.lis
