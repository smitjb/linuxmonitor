col snap_interval format a20
col retention format a20
select snap_interval, retention
from dba_hist_wr_control;