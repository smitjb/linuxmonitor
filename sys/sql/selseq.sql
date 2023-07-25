select
 SEQUENCE_NAME,
 substr(MIN_VALUE,1,18) min_value,
 substr(MAX_VALUE,1,18) max_value,
 INCREMENT_BY ,
 CYCLE_FLAG  ,
 ORDER_FLAG,
 CACHE_SIZE,
 substr(LAST_NUMBER,1,18) LAST_NUMBER
 from user_sequences
/
