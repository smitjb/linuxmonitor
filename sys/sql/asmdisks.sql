select grp.name grp_name,  grp.state grp_state,dsk.failgroup,label,substr(path,1,30) path,
dsk.mode_status,
dsk.os_mb,dsk.total_mb,dsk.free_mb, round((dsk.free_mb/dsk.total_mb)*100,0) pct_free
--, dsk.* 
from v$asm_diskgroup grp inner join v$asm_disk dsk
on grp.group_number=dsk.group_number
where grp.name like upper(nvl('&1',grp.name))
order by grp.name, dsk.failgroup, dsk.label ;
