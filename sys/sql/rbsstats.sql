select name, round(rssize/(1024*1024),2) rssize, round(hwmsize/(1024*1024),2) hwm ,extents, round(optsize/(1024*1024),2) opt ,round(aveactive/(1024*1024),2) aveactive,status,shrinks  
from v$rollstat s,v$rollname n 
where s.usn=n.usn 
order by name;