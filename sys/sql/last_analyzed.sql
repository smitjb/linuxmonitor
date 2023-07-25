select min(last_analyzed),max(last_analyzed) ,owner from dba_tables group by owner order by 2
/
