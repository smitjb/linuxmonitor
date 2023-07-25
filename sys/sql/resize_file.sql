--
-- $Header: /jbs/var/cvs/orascripts/sql/resize_file.sql,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
--
-- Short cut to resize a data file
--

define datafile=&1
define size=&2
 alter database datafile '&datafile' resize &size;
