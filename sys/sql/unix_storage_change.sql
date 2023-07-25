--
-- report in the change in the storage allocated on a unix host
-- o 'system disk' is ignored. Database relevant filesystems
--   are assumed to be /u[nn] (1-16) and /backup
-- o excludes shared infrastructure and other systems where the filesystems are non standard
--
-- 
SELECT target_name,
  MIN ( value )   ,
  MAX ( value ),
  max(value)-min(value)
FROM
  (SELECT ht.target_name                  ,
    m.rollup_timestamp        AS rollup_timestamp,
    ROUND ( SUM ( maximum ) ) AS value
  FROM mgmt$metric_daily m,
    mgmt$target ht
  WHERE
    ht.target_type          ='host'
    AND m.target_guid       =ht.target_guid
    AND m.metric_name       ='Filesystems'
    AND ( m.metric_column   ='size' )
    AND ( m.key_value like '/sg%/u__'
          or  m.key_value like '/sg%/backup'
          or  m.key_value like '/u__'
          or  m.key_value = '/backup'
          or m.key_value like '_:\' )
 )
    AND m.rollup_timestamp >= to_date('&period_start','dd-mon-yyyy')
    AND m.rollup_timestamp <= to_date('&period_end','dd-mon-yyyy')
  GROUP BY ht.target_name,
    m.rollup_timestamp
  )
GROUP BY target_name
ORDER BY target_name;