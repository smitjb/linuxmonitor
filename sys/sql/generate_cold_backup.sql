set lines 1000
set pages 0
set heading off
set echo off
set feedback off
set trimspool on
set trimout on
set verify off
define db=&1
define backup_dir=&2

spool &db.cold_backup.sh
select 'cp '|| file_name ||' &&backup_dir/'|| replace(file_name,'/','-')
from dba_data_files
UNION 
select 'cp '|| file_name ||' &&backup_dir/'|| replace(file_name,'/','-')
from dba_temp_files
UNION 
select 'cp '|| name ||' &&backup_dir/'|| replace(name,'/','-')
from v$controlfile
UNION 
select 'cp '|| member ||' &&backup_dir/'|| replace(member,'/','-')
from v$logfile;
spool off

spool &db.cold_restore.sh
select 'cp  &&backup_dir/'|| replace(file_name,'/','-')||' '||file_name
from dba_data_files
UNION 
select 'cp &&backup_dir/'|| replace(name,'/','-')||' '|| name 
from v$controlfile
UNION 
select 'cp &&backup_dir/'|| replace(member,'/','-')||' '|| member
from v$logfile;
spool off

spool &db._delete_dataase.sh
select 'rm '|| file_name 
from dba_data_files
UNION 
select 'rm '|| file_name 
from dba_temp_files
UNION 
select 'rm '|| name 
from v$controlfile
UNION 
select 'rm '|| member 
from v$logfile;

spool off
