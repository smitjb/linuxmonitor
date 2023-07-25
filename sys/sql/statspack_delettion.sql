--  Delete all data for the specified ranges

select min( snap_time) + 10 from stats$snapshot  ss
 where ss.dbid =786057097   ;


select d.dbid
     , d.name
     , i.instance_number
     , i.instance_name
  from v$database d,
       v$instance i;


/*  Use RI to delete parent snapshot and all child records  */

select count(1) 
 from stats$snapshot ss
 where ss.instance_number = 1
   and ss.dbid            = 786057097
   and ss.snap_time < '29-MAR-2008 11:34:10' ;

   insert into purge_records values  ( sysdate, 'Deleting ' || recs || ' rows from stats$snapshot' );
   commit ;

select count(1) from stats$snapshot ss
 where ss.instance_number = 1
   and ss.dbid            = 786057097
   and ss.snap_time < '29-MAR-2008 11:34:10'  ;


--  Delete any dangling SQLtext
--  The following statement deletes any dangling SQL statements which
--  are no longer referred to by ANY snapshots.

select count(1)  /*+ hash_aj */
  from stats$sqltext st
 where (hash_value, text_subset) not in
       (select hash_value, text_subset
          from stats$sql_summary
        );


-- Adding an optional STATS$SEG_STAT_OBJ delete statement

select count(*) --+ index_ffs(sso)
  from stats$seg_stat_obj sso
 where (sso.dbid, dataobj#, obj#) not in
       (select ss.dbid, dataobj#, obj#
          from stats$seg_stat ss
        );


--Delete any undostat rows that cover the snap times

select count(*) from perfstat.stats$undostat us
 where 786057097            = 786057097
   and instance_number = 1
   and begin_time      <  '29-MAR-2008 11:34:10'  ;



--Delete any dangling database instance rows for that startup time

select count(*) from perfstat.stats$database_instance di
 where di.instance_number = 1
   and di.dbid            = 786057097
   and not exists (select 1
                     from perfstat.stats$snapshot s
                    where s.dbid            = di.dbid
                      and s.instance_number = di.instance_number
                      and s.startup_time    = di.startup_time);



--Delete any dangling statspack parameter rows for the database instance

select count(*) from perfstat.stats$statspack_parameter sp
 where sp.instance_number = 1
   and sp.dbid            = 786057097
   and not exists (select 1
                     from perfstat.stats$snapshot s
                    where s.dbid            = sp.dbid
                      and s.instance_number = sp.instance_number);


