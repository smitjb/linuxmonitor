-- #########################################################
-- # Name    : mon_ts_size.sql
-- # Author  : AM Morris
-- # Date    : October 2001
-- # Purpose : Check tablespace sizes, free space, pct free
-- # Calling routines : None
-- # Called routines : None
-- # Notes   : Present info on tablespace files, use and space
-- # Usage   : @mon_ts_size.sql
-- #
-- # Modified
-- # By        Date     Reason
-- # ========= ======== ====================================
-- # AR Morris ?        This routine was ignoring files that
-- #                    had reached 100% capacity. Missed
-- #                    out from earlier install.
-- #########################################################

column tablespace_name format a15 heading "Tablespace name"
column file_name format a50       heading "File name"
column meg format 999999999       heading "Free"
column file_size format 999999999 heading "File size"
column pct format a5              heading "Pct free"


select tablespace_name, file_name, file_size, meg, ceil((meg/file_size)*100)||'%' pct
from (select d.tablespace_name
            ,d.file_name
            ,floor(d.bytes/1048576)        file_size
            ,floor(sum(f.bytes) / 1048576) meg
     from dba_free_space f
         ,dba_data_files d
     where f.file_id(+) = d.file_id
     group by d.tablespace_name
             ,d.file_name
             ,d.bytes)
order by 1,2

spool /tmp/ts_size.lst
/

spool off

