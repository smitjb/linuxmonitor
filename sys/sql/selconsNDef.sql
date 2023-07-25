
break on table_name

SELECT 'ALTER TABLE ' || substr(b.TABLE_NAME,1,30) || ' DROP CONSTRAINT ' || substr(b.CONSTRAINT_NAME,1,30) || ';'
FROM   user_constraints   a,
       user_cons_columns  b
where  a.constraint_name = b.constraint_name
and    a.owner           = b.owner
and    a.table_name      = b.table_name
and    a.constraint_name not like 'SYS%'
and    b.constraint_name not like 'SYS%'
and    a.DEFERRABLE      != 'DEFERRABLE'
AND    a.constraint_type != 'P'
order by b.TABLE_NAME, b.COLUMN_NAME, a.constraint_type, a.status;


SELECT substr(b.TABLE_NAME,1,30)      table_name,
       substr(b.COLUMN_NAME,1,30)     column_name,
       substr(b.CONSTRAINT_NAME,1,30) constraint_name,
       substr(a.constraint_type,1,10) con_type,
       a.status,
       a.DEFERRABLE,
       substr(a.DEFERRED,1,20) DEFERRED,
       substr(b.POSITION,1,5) postn
FROM   user_constraints   a,
       user_cons_columns  b
where  a.constraint_name = b.constraint_name
and    a.owner           = b.owner
and    a.table_name      = b.table_name
and    a.constraint_name not like 'SYS%'
and    b.constraint_name not like 'SYS%'
and    a.DEFERRABLE      != 'DEFERRABLE'
AND    a.constraint_type != 'P'
order by b.TABLE_NAME, b.COLUMN_NAME, a.constraint_type, a.status;

break on wind
