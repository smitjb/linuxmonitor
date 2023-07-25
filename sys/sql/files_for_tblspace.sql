define tblspc=&1;
col file_name format a60
select 'data',file_id,file_name, 
	round(bytes/(1024*1024)) MB,
        round(maxbytes/(1024*1024)) maxMB
from dba_data_files 
where tablespace_name=upper('&tblspc')
union
select 'temp',file_id,file_name, 
	round(bytes/(1024*1024)) MB,
        round(maxbytes/(1024*1024)) maxMB
from dba_temp_files 
where tablespace_name=upper('&tblspc')
;