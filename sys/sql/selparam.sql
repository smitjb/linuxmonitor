select substr(NUM,1,4) NUM,
       substr(NAME,1,25) name,
       TYPE,
       substr(VALUE,1,40) value,
       ISDEFAULT,
       ISADJUSTED,
       substr(DESCRIPTION,1,60) description
FROM   sys.v_$parameter
where  name like '%&likename%'
order by name
/

