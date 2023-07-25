--
-- $Header: /jbs/var/cvs/orascripts/sql/short_tablespaces.sql,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
--
-- Tablesspaces with free space below a threshold (30%)
--
break on report
compute sum of total free used on report
SELECT T.TABLESPACE_NAME TBLSPC,
       ROUND(T.BYTES/(1024*1024) ) TOTAL,
       ROUND(SUM(F.BYTES)/(1024*1024)) FREE,
       ROUND((SUM(F.BYTES)/T.BYTES * 100)) FREEPCT,
       ROUND(T.BYTES/(1024*1024) ) -ROUND(SUM(F.BYTES)/(1024*1024)) USED,
       ROUND(((T.BYTES-SUM(F.BYTES))/T.BYTES) *100) USEDPCT,
       round((T.BYTES/(1024*1024)  -SUM(F.BYTES)/(1024*1024))/0.75) required 
FROM SYS.DBA_FREE_SPACE F,
     (SELECT TABLESPACE_NAME, SUM(BYTES)   BYTES
      FROM SYS.DBA_DATA_FILES
      GROUP BY  TABLESPACE_NAME
       UNION 
       SELECT TABLESPACE_NAME, SUM(BYTES)   BYTES
      FROM SYS.DBA_TEMP_FILES
      GROUP BY  TABLESPACE_NAME ) T
WHERE T.TABLESPACE_NAME=F.TABLESPACE_NAME(+)
GROUP BY T.TABLESPACE_NAME,T.BYTES
having  ROUND((SUM(F.BYTES)/T.BYTES * 100)) < 30
ORDER BY T.TABLESPACE_NAME; 