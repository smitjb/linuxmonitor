select substr(segment_name,1,30), round(bytes/(1024*1024)) mb from dba_segments where owner='KWTRADE' AND SEGMENT_NAME NOT LIKE 'BIN$%' AND BYTES > (1024*1024) ORDER BY BYTES 
/
