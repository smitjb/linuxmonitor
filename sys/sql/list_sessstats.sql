select sysdate,se.sid, sn.name, st.value, sn.class
from v$session se 
  inner join v$sesstat st 
  on se.sid=st.sid
  inner join v$statname sn 
  on sn.statistic#=st.statistic#
  and se.sid=&1
order by sn.class, sn.name
/

