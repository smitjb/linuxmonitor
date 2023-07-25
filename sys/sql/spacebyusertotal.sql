select  distinct(ts.name), sum(seg.blocks*ts.blocksize)/1024  K
from    sys.ts$ ts,
        sys.user$ us,
        sys.seg$ seg
where   seg.user# = us.user#
and     ts.ts# = seg.ts#
group by ts.name, us.name,ts.name
order by 2,1
/
