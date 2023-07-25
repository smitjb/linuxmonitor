select DEFERRED_TRAN_ID,
       DELIVERY_ORDER,
       DESTINATION_LIST,
       to_char(START_TIME,'DD-MON-YYYY HH24:MI:SS') start_time
from   deftran
order by 4;

select DESTINATION_LIST, count(*) from deftran group by DESTINATION_LIST;

