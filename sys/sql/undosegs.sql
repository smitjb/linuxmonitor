select SEGMENT_NAME, TABLESPACE_NAME, ROUND(BYTES/(1024*1024)) mb from dba_segments where segment_type='TYPE2 UNDO'
/
