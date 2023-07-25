break on table_name
col orderby   form 9    noprint

select '1' orderby,
       substr(b.TABLE_NAME,1,30)      table_name,
       substr(b.COLUMN_NAME,1,25)     column_name,
       substr(b.CONSTRAINT_NAME,1,25) constraint_name,
       substr(a.constraint_type,1,10) con_type,
       substr(a.R_CONSTRAINT_NAME,1,15) references_this,
       a.status
FROM   user_constraints   a,
       user_cons_columns  b
where  a.constraint_name   = b.constraint_name
and    a.constraint_name   like upper('&&pk_suffix%')
and    a.owner             = b.owner
and    a.table_name        = b.table_name
and    a.constraint_type   = 'P'
and    a.constraint_name   not like 'SYS%'
and    b.constraint_name   not like 'SYS%'
UNION
select '2' orderby,
       substr(b.TABLE_NAME,1,30)      table_name,
       substr(b.COLUMN_NAME,1,25)     column_name,
       substr(b.CONSTRAINT_NAME,1,25) constraint_name,
       substr(a.constraint_type,1,10) con_type,
       substr(a.R_CONSTRAINT_NAME,1,15) references_this,
       a.status
FROM   user_constraints   a,
       user_cons_columns  b
where  a.constraint_name   = b.constraint_name
and    a.r_constraint_name like upper('&&pk_suffix%')
and    a.owner             = b.owner
and    a.table_name        = b.table_name
and    a.constraint_type   = 'R'
and    a.constraint_name   not like 'SYS%'
and    b.constraint_name   not like 'SYS%'
order by 1,2,5,6
/
break on wind

