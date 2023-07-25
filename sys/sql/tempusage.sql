--
-- $Header: /jbs/var/cvs/orascripts/sql/tempusage.sql,v 1.1.1.1 2012/12/28 17:34:15 jim Exp $
--
-- Display temp usage
--
select sum( u.blocks * blk.block_size)/1024/1024 "Mb. in sort segments"
, (hwm.max * blk.block_size)/1024/1024 "Mb. High Water Mark"
from v$sort_usage u, (select block_size
from dba_tablespaces
where contents = 'TEMPORARY') blk
, (select segblk#+blocks max
from v$sort_usage
where segblk# = (select max(segblk#) from v$sort_usage) ) hwm
group by hwm.max * blk.block_size/1024/1024;
