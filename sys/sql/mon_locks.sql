-- #########################################################
-- # Name    : mon_locks.sql
-- # Author  : Nextgen DBA Team
-- # Date    : January 2002
-- # Purpose : Reports database locks and processes to kill
-- # Calling routines : None
-- # Called routines : None
-- # Notes   : Connect as sysdba
-- # Usage   : @mon_locks.sql
-- #
-- # Modified
-- # By        Date     Reason
-- # ========= ======== ====================================
-- #
-- #########################################################

set linesize 160 pagesize 66
break on Kill on username on terminal on machine

column Kill 	format a13	heading 'Kill String' 
column res 	format 999	heading 'Resource Type' 
column id1 	format 9999990
column id2 	format 9999990
column lmode 	format a20	heading 'Lock Held' 
column request 	format a20	heading 'Lock Requested' 
column serial# 	format 99999
column username format a13  	heading "Username"
column terminal format a15	heading Term 
column machine  format a15	heading Term 
column tab 	format a35 	heading "Table Name"
column owner 	format a9
column Address 	format a18

select  nvl(S.USERNAME,'Internal') 		username,
        nvl(S.TERMINAL,'None') 			terminal,
        ''''||L.SID||','||S.SERIAL#||'''' 	Kill,
        substr(s.machine,1,15) 			machine,
        U1.NAME||'.'||substr(T1.NAME,1,20) 	tab,
        decode(L.LMODE,1,'No Lock',
                2,'Row Share',
                3,'Row Exclusive',
                4,'Share',
                5,'Share Row Exclusive',
                6,'Exclusive',null) 		lmode,
        decode(L.REQUEST,1,'No Lock',
                2,'Row Share',
                3,'Row Exclusive',
                4,'Share',
                5,'Share Row Exclusive',
                6,'Exclusive',null) 		request
from    V$LOCK L,
        V$SESSION S,
        SYS.USER$ U1,
        SYS.OBJ$ T1
where   L.SID = S.SID
and     T1.OBJ# = decode(L.ID2,0,L.ID1,L.ID2)
and     U1.USER# = T1.OWNER#
and     S.TYPE != 'BACKGROUND'
order by 1,2,6
/
