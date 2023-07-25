select db.name,rot.* from rman10.rc_database db left outer join rman10.rc_database_block_corruption rot
 on db.db_key=rot.db_key
 order by name, file#,block#;

