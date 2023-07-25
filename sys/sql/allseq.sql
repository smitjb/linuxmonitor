break on sequence_owner

select
 sequence_owner,
 SEQUENCE_NAME,
 substr(MIN_VALUE,1,18) min_value,
 substr(MAX_VALUE,1,18) max_value,
 INCREMENT_BY ,
 CYCLE_FLAG  ,
 ORDER_FLAG,
 CACHE_SIZE,
 substr(LAST_NUMBER,1,18) LAST_NUMBER
from all_sequences
where sequence_owner in ('RDTEMP','RDCRUISEBS1','DETEMP','DECRUISEBS1','TITEMP','TICRUISEBS1','CGTEMP','CGCRUISEBS1','TBTEMP','TBCRUISEMW1')
order by 1,2
/

