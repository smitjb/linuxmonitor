break on owner

SELECT substr(OWNER,1,16) owner,
       SYNONYM_NAME,
       ' based on  ',
       SUBSTR(table_owner,1,20) || '.' || SUBSTR(table_name,1,30) owner_table
FROM   all_synonyms
WHERE  owner NOT IN ('SYS','SYSTEM','PUBLIC','DBSNMP')
ORDER BY 1,2,3;

break on wind 


