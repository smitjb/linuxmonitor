
column kghlurcr heading "RECURRENT|CHUNKS"
column kghlutrn heading "TRANSIENT|CHUNKS"
column kghlufsh heading "FLUSHED|CHUNKS"
column kghluops heading "PINS AND|RELEASES"
column kghlunfu heading "ORA-4031|ERRORS"
column kghlunfs heading "LAST ERROR|SIZE"

ttitle 'Report on 4031 events (SYS user only)'
spool cpu_stats

select
kghlurcr,
kghlutrn,
kghlufsh,
kghluops,
kghlunfu,
kghlunfs
from
sys.x$kghlu
where
inst_id = userenv('Instance')
;

spool off
clear columns
ttitle off
