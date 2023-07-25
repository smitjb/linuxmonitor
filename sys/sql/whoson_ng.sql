select 'Deal Entry' as module, USERNAME,  max(EXPIRE_TIME) as LASTLOGIN 
from DEOWNERBS1.NGIPR_IP_RESOLVER group by USERNAME 
union 
select 'Ref Data' as module, USERNAME,  max(EXPIRE_TIME) as LASTLOGIN 
from RdOWNERBS1.NGIPR_IP_RESOLVER group by USERNAME  
union 
select 'CST' as module, USERNAME,  max(EXPIRE_TIME) as LASTLOGIN 
from csOWNERBS1.NGIPR_IP_RESOLVER group by USERNAME 
order by LASTLOGIN desc;
