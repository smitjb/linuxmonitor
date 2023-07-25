select 'RDCRUISEBS1'                                      owner,
       SUBSTR(DB_LABEL,1,40)                              DB_LABEL,
       SUBSTR(DATA_LABEL,1,40)                            DATA_LABEL,
       TO_CHAR(LAST_UPDATE_TIME,'DD-MON-YYYY HH24:MI:SS') LAST_UPDATE_TIME
from   RDCRUISEBS1.DEPLOYMENT_LABEL
UNION
select 'DECRUISEBS1'                                      owner,
       SUBSTR(DB_LABEL,1,40)                              DB_LABEL,
       SUBSTR(DATA_LABEL,1,40)                            DATA_LABEL,
       TO_CHAR(LAST_UPDATE_TIME,'DD-MON-YYYY HH24:MI:SS') LAST_UPDATE_TIME
from   DECRUISEBS1.DEPLOYMENT_LABEL
UNION
select 'TICRUISEBS1'                                      owner,
       SUBSTR(DB_LABEL,1,40)                              DB_LABEL,
       SUBSTR(DATA_LABEL,1,40)                            DATA_LABEL,
       TO_CHAR(LAST_UPDATE_TIME,'DD-MON-YYYY HH24:MI:SS') LAST_UPDATE_TIME
from   TICRUISEBS1.DEPLOYMENT_LABEL
UNION
select 'CGCRUISEBS1'                                      owner,
       SUBSTR(DB_LABEL,1,40)                              DB_LABEL,
       SUBSTR(DATA_LABEL,1,40)                            DATA_LABEL,
       TO_CHAR(LAST_UPDATE_TIME,'DD-MON-YYYY HH24:MI:SS') LAST_UPDATE_TIME
from   CGCRUISEBS1.DEPLOYMENT_LABEL
UNION
select 'TBCRUISEMW1'                                      owner,
       SUBSTR(DB_LABEL,1,40)                              DB_LABEL,
       SUBSTR(DATA_LABEL,1,40)                            DATA_LABEL,
       TO_CHAR(LAST_UPDATE_TIME,'DD-MON-YYYY HH24:MI:SS') LAST_UPDATE_TIME
from   TBCRUISEMW1.DEPLOYMENT_LABEL
/
