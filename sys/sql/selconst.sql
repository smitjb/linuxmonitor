SELECT substr(a.OWNER,1,15) 	owner,
       substr(a.CONSTRAINT_NAME,1,15) CONSTRAINT_NAME,
       a.CONSTRAINT_TYPE,
       substr(a.TABLE_NAME,1,20) table_name,
       substr(a.R_OWNER,1,15)  r_owner,
       substr(a.R_CONSTRAINT_NAME,1,15) R_CONSTRAINT_NAME,
       a.DELETE_RULE,
       a.STATUS,
       substr(a.DEFERRABLE,1,7) deffrbl,
       substr(a.DEFERRED,1,5)   defrd,
       a.VALIDATED,
       a.GENERATED,
       a.BAD,
       a.RELY ,
       a.LAST_CHANGE,
       b.DATA_DEFAULT,
       a.SEARCH_CONDITION
FROM   user_constraints  a,
       user_tab_columns  b
WHERE  a.table_name  = b.table_name
AND    a.column_name = b.column_name
AND    a.table_name  = UPPER('&tablename');
