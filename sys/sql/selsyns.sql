column synonym_name   heading "synonym_name"       format a25
column table_owner    heading "table owner"        format a25
column table_name     heading "table name"         format a25
column db_link        heading "Databae link"       format a20


select substr(synonym_name,1,25)       synonym_name,
       '  for  ',
       rtrim(substr(table_owner,1,25)) table_owner,
       '.',
       substr(table_name,1,25)         table_name,
       SUBSTR(db_link,1,20)            db_link
from   user_synonyms
order by db_link,
         table_name,
         synonym_name,
         table_owner;
