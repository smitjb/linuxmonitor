
column  ow    heading "Schema Owner"   format a25
column  ta    heading "Tablespace"     format a30
column  k     heading "Size in K"      format 9999999999

select  us.name                                 ow,
        ts.name                                 ta,
        sum(seg.blocks*ts.blocksize)/1024       K 
from    sys.ts$ ts,
        sys.user$ us,
        sys.seg$ seg
where   seg.user# = us.user#
and     ts.ts# = seg.ts#
group by us.name,ts.name
order by 3 DESC
/


-- SELECT owner,
--        table_name  object_name,
--        'TABLE'     type,
--        tablespace_name
-- FROM   dba_tables
-- WHERE  owner LIKE 'CGOWNER%'
-- AND    tablespace_name NOT LIKE 'CG%'
-- UNION
-- SELECT owner,
--        index_name  object_name,
--        'INDEX'     type,
--        tablespace_name
-- FROM   dba_indexes
-- WHERE  owner LIKE 'CGOWNER%'
-- AND    tablespace_name NOT LIKE 'CG%'
-- ORDER BY 1,3,4;
