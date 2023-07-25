clear columns
clear breaks
column	file#		format 999	Heading "File"
column	ct		format 999999	heading "Waits"
column	time		format 999999	heading "Time"
column	avg		format 999.999	heading	"Avg time"
column	filename        format a50      heading	"filename"
column	tablespace_name format a30      heading	"Tablespace"

spool file_wait

select  wt.indx+1		file#,
        df.name                 filename,
        ts.name                 tablespace_name,
	wt.count		ct,
	wt.time,
	wt.time/(decode(wt.count,0,1,wt.count))	avg
from    x$kcbfwait   wt,
        v$datafile   df,
        v$tablespace ts
where   wt.indx < (select count(*) from v$datafile)
and     wt.indx+1   = df.file#
and     df.ts#      = ts.ts#;

spool off

