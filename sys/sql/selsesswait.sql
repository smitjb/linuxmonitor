SELECT SID, 
       SUBSTR(STATE,1,20)   STATE,
       SEQ#, 
       SUBSTR(EVENT,1,20)   EVENT,
       SUBSTR(P1TEXT,1,15)  P1TEXT,
       SUBSTR(P1,1,10)       P1,
       SUBSTR(P2TEXT,1,15)  P2TEXT,
       SUBSTR(P2,1,10)      P2,
       --SUBSTR(P3TEXT,1,15) P3TEXT,
       --SUBSTR(P3,1,10)     P3,
       WAIT_TIME,
       SECONDS_IN_WAIT
FROM   v$session_wait
ORDER BY 1,2;
