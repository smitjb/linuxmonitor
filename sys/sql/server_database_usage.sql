--
-- server_database_usage
--
-- Lists the number and total size of databases on a host.
--
-- =========================================================================
select
        hst.target_name,
        count( distinct db.target_name),
        sum(value)
      FROM
        mgmt$metric_current m,
        mgmt$target hst,
        mgmt$target db,
        MGMT$TARGET_ASSOCIATIONS a
      WHERE
       hst.target_type='host'
       and a.source_target_type = 'oracle_database'
       and a.assoc_target_name = hst.TARGET_NAME
       and hst.TARGET_TYPE = 'host'
       and a.source_target_name = db.TARGET_NAME
       and db.TARGET_TYPE = 'oracle_database'
       AND
        (db.target_type='rac_database' OR
        (db.target_type='oracle_database' AND db.TYPE_QUALIFIER3 != 'RACINST')) AND
        m.target_guid=db.target_guid AND
        m.metric_name='tbspAllocation' AND
        m.metric_column='spaceAllocated' 
      GROUP BY hst.target_name;
