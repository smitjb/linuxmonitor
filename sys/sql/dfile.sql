select substr(FILE_NAME,1,55) filename,
       substr(FILE_ID,1,2) f#,
       substr(TABLESPACE_NAME,1,15) tablespace,
       BYTES,
       BLOCKS,
       STATUS,
       substr(RELATIVE_FNO,1,2) rf,
       AUTOEXTENSIBLE,
       substr(MAXBYTES,1,7)     MAXBYTS,
       substr(MAXBLOCKS,1,7)    MAXBLKS,
       substr(INCREMENT_BY,1,6) INC_BY,
       USER_BYTES,
       USER_BLOCKS
FROM   dba_data_files
order by file_name, tablespace_name, file_id;

@spaceproc
