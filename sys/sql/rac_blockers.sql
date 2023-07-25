column sess format A20
SELECT substr(DECODE(request,0,'Holder: ','Waiter: ')||sid,1,12) sess,
       id1, id2, lmode, request, type, inst_id
 FROM GV$LOCK
WHERE (id1, id2, type) IN
   (SELECT id1, id2, type FROM GV$LOCK WHERE request>0)
     ORDER BY id1, request;