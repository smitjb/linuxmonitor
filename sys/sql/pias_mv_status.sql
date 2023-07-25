select NAME, LAST_REFRESH from dba_snapshot_refresh_times where owner='MV' ORDER BY LAST_REFRESH DESC;

SELECT SYSDATE, substr(WHAT,1,30) what, LAST_SEC,THIS_SEC,NEXT_SEC,failures, broken FROM DBA_JOBS WHERE LOG_USER = 'MV';