define oldname=&1
define newname=&2
set lines 500
set pages 40
set feedback off
set heading off
set verify off
set timing off
set trimspool on
set trimout on
select 'create tablespace '||dt.tablespace_name,
  'datafile '''||replace(df.file_name,'&oldname','&newname')||'''',
  'size '||df.bytes,
  'extent management local uniform size '||DT.MIN_EXTLEN, 
  'segment space management '|| dt.segment_space_management
from dba_tablespaces dt, (select file_name,tablespace_name,bytes from dba_data_files
where  file_name like '%01.dbf') df
where df.tablespace_name = dt.tablespace_name
AND dt.TABLESPACE_NAME NOT IN ('SYSTEM','SYSAUX','USERS','TOOLS','TEMP','UNDOTBS')
order by dt.tablespace_name;

select 'alter tablespace '||dt.tablespace_name,
  'add datafile '''||replace(df.file_name,'&oldname','&newname')||'''',
  'size '||df.bytes
from dba_tablespaces dt, (select file_name,tablespace_name,bytes from dba_data_files
where not file_name like '%01.dbf') df
where df.tablespace_name = dt.tablespace_name
AND dt.TABLESPACE_NAME NOT IN ('SYSTEM','SYSAUX','USERS','TOOLS','TEMP','UNDOTBS')
order by dt.tablespace_name;
