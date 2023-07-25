select tablespace_name, file_name,bytes/(1024*1204)
from dba_data_files where tablespace_name=UPPER('&1');