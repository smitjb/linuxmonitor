select dsrt.* from dba_refresh dr
inner join dba_refresh_children drc
on dr.refgroup=drc.refgroup
inner join dba_snapshot_refresh_times dsrt
on drc.owner = dsrt.owner
and drc.name=dsrt.name
where DR.ROWNER=upper(nvl('&2',user))
and dr.rname=upper('&1')
order by last_refresh;
