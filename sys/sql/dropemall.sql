-- 
-- $Header: /jbs/var/cvs/orascripts/sql/dropemall.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
--
-- Drop everything
--
--
set heading off
set linesize 80
set feedback off

spool dropdemtings.sql

select 'drop table '    || table_name    || ' cascade constraints;'  nonesense
from   user_tables
union
select 'drop sequence ' || sequence_name || ';'                      nonesense
from   user_sequences
union
select 'drop synonym '  || synonym_name  || ';'                      nonesense
from   user_synonyms
union     
select 'drop view '     || view_name     || ';'                      nonesense
from   user_views
union     
select 'drop type '     || type_name     || ';'                      nonesense
from   user_types
union
select 'drop trigger '  || trigger_name  || ';'                      nonesense
from   user_triggers
union     
select 'drop package '  || object_name   || ';'                      nonesense
from   user_objects 
where  object_type = 'PACKAGE'   
union     
select 'drop package body '  || object_name   || ';'                 nonesense
from   user_objects 
where  object_type = 'PACKAGE BODY'   
union     
select 'drop procedure ' || object_name   || ';'                     nonesense
from   user_objects 
where  object_type = 'PROCEDURE'   
union
select 'drop function ' || object_name   || ';'                      nonesense
from   user_objects 
where  object_type = 'FUNCTION'
UNION
SELECT 'DROP DATABASE LINK ' || db_link  || ';'                      nonesense
FROM   user_db_links;     

spool off

select substr(global_name,1,20) global_name 
from   global_name;

show user

select 'Thats your lot.'
from   dual;

!hostname

select 'Now run @dropdemtings.sql' from dual;

set heading on
set linesize 180
set feedback on


