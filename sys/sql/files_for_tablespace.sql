--
-- $Header: /jbs/var/cvs/orascripts/sql/files_for_tablespace.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
-- 
-- List files and sizes for a named tablespace
--
define tblspc=&1;

select file_name, 
	bytes/(1024*1024) 
from dba_data_files 
where tablespace_name=upper('&tblspc');