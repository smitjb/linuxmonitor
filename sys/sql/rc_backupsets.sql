
SELECT *
   FROM rc_backup_set rbs
INNER JOIN rc_database rd
     ON rbs.db_key=rd.db_key
  WHERE rd.name ='SDBAORV2'
  ORDER BY START_TIME;
