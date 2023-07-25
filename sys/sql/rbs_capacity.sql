--select name, ses_addr, xidusn,addr,used_ublk from v$transaction,v$rollname where xidusn=usn;

select r.name, round(sum(used_ublk*b.value)/(1024)) used, v.rssize/1024 total 
from v$transaction, v$rollname r , v$parameter b, v$rollstat v
where xidusn=r.usn 
and r.usn=v.usn and 
b.name='db_block_size'
group by r.name,v.rssize/1024;