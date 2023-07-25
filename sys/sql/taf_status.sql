COLUMN instance_name    FORMAT a13
COLUMN host_name        FORMAT a9
COLUMN failover_method  FORMAT a15
COLUMN failed_over      FORMAT a11

SELECT
    instance_name
  , host_name
  , NULL AS failover_type
  , NULL AS failover_method
  , NULL AS failed_over
FROM v$instance
UNION
SELECT
    NULL
  , NULL
  , failover_type
  , failover_method
  , failed_over
FROM v$session
WHERE username = user;
