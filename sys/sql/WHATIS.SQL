set heading off 
set verify off
col seq noprint
select 5,'LOCAL TABLE'
FROM USER_tableS
WHERE TABLE_NAME LIKE UPPER('&&1')
UNION
select 10 seq ,'PUBLIC SYNONYM for '|| table_owner||'.'||table_name
FROM ALL_SYNONYMS
WHERE OWNER='PUBLIC'
AND SYNONYM_NAME LIKE UPPER('&&1')
UNION
select 20,'LOCAL SYNONYM for '|| table_owner||'.'||table_name
FROM USER_SYNONYMS
WHERE SYNONYM_NAME LIKE UPPER('&&1')
UNION
SELECT 130, 'MATERIALIZED VIEW in:'||owner
FROM ALL_MVIEWS
WHERE MVIEW_NAME LIKE UPPER('&&1')
UNION
SELECT 140, 'VIEW in:'||owner
FROM ALL_VIEWS
WHERE VIEW_NAME LIKE UPPER('&&1')
UNION
SELECT 150, 'TABLE in:'||owner
FROM ALL_TABLES
WHERE TABLE_NAME LIKE upper('&&1')
order by 1;
set heading on
