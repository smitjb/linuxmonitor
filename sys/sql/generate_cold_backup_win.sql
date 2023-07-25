set lines 1000
set pages 0
set heading off
set echo off
set feedback off
set trimspool on
set trimout on
define db=&1
define backup_dir=&2

spool &db.cold_backup.cmd
select 'copy '|| file_name ||' &&backup_dir\'|| replace(replace(file_name,'\','-'),':','$')
from dba_data_files
UNION 
select 'copy '|| name ||' &&backup_dir\'|| replace(replace(name,'\','-'),':','$')
from v$controlfile
UNION 
select 'copy '|| member ||' &&backup_dir\'|| replace(replace(member,'\','-'),':','$')
from v$logfile;
spool off

spool &db.cold_restore.cmd
select 'copy  &&backup_dir\'|| replace(replace(file_name,'\','-'),':','$')||' '||file_name
from dba_data_files
UNION 
select 'copy &&backup_dir\'|| replace(replace(name,'\','-'),':','$')||' '|| name 
from v$controlfile
UNION 
select 'copy &&backup_dir\'|| replace(replace(member,'\','-'),':','$')||' '|| member
from v$logfile;
spool off
