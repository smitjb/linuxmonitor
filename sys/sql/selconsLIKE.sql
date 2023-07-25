break on table_name
select substr(b.TABLE_NAME,1,30)      table_name,
       substr(b.COLUMN_NAME,1,30)     column_name,
       substr(b.CONSTRAINT_NAME,1,25) constraint_name,
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
and    a.constraint_name     like '&cons%'
order by 1,2,4,5
/

select substr(b.TABLE_NAME,1,30)      table_name,
       substr(b.COLUMN_NAME,1,30)     column_name,
       substr(b.CONSTRAINT_NAME,1,25) constraint_name,
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
and    b.column_name         like '&cols%'
order by 1,2,4,5
/

break on wind
