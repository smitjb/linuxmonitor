select count(*) 
from   system.def$_aqcall
where  cscn < (select last_delivered 
               from   system.def$_destination where dblink ='<DBLINK>'); 
  
