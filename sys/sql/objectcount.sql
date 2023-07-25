set linesize 200
break on report
compute sum of cnt on report
compute sum of tab on report
compute sum of pack on report
compute sum of bod on report
compute sum of proc on report
compute sum of func on report
compute sum of vie on report
compute sum of mv on report
compute sum of trg on report
compute sum of syn on report
compute sum of typ on report

select owner, 
  count(*) cnt,
  sum(decode(OBJECT_TYPE,'TABLE',1,0)) tab,
  sum(decode(OBJECT_TYPE,'PACKAGE',1,0)) pack,
  sum(decode(OBJECT_TYPE,'PACKAGE BODY',1,0)) bod,
  sum(decode(OBJECT_TYPE,'PROCEDURE',1,0)) proc,
  sum(decode(OBJECT_TYPE,'FUNCTION',1,0)) FUNC,
  sum(decode(OBJECT_TYPE,'VIEW',1,0)) VIE,
  sum(decode(OBJECT_TYPE,'MATERIALIZED VIEW',1,0)) MV,
  sum(decode(OBJECT_TYPE,'TRIGGER',1,0)) TRG,
  sum(decode(OBJECT_TYPE,'SYNONYM',1,0)) syn,
  sum(decode(OBJECT_TYPE,'TYPE',1,0)) TYP
  from dba_objects  
  group by owner
/
clear breaks