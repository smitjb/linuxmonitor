break on coll_name skip
select coll_name, co_name, co_label, cs_timestamp, cs_stat_value
from collection
    inner join collection_objects
     on co_coll_id = coll_id
   inner join collected_stat
    on cs_co_id=co_id
order by cs_timestamp, coll_name, co_label;