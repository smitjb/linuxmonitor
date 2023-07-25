-- #############################################################################
-- # Name   : adm_show_locks.sql
-- # Author : Des Fox
-- # Date   : June 2002
-- # Purpose: To list locked tables by owning session id.
-- # Calling routine:
-- # Called routine:
-- # Parameter files:
-- # Notes  : Run as DBA privileged user.
-- # Usage  :
-- # Modified:
-- # By          When     Change
-- # ----------- -------- ------------------------------------------------------
-- #############################################################################



SELECT SUBSTR(ses.username, 1, 13) username,
       ses.sid,
       SUBSTR(ses.osuser,1,15) osuser,
       ses.process,
       ses.status,
       ses.server,
       ses.type,
       decode(lck.type,'RW','Row Wait','TX','Transaction','UL','PL/SQL','TM','DML') lock_type,
       DECODE(lck.lmode, 1, 'NULL',
                         2, 'ROW SHARE',
                         3, 'ROW EXC.',
                         4, 'SHARE',
                         5, 'SHARE ROW EXC.',
                         6, 'EXCLUSIVE') LMODE,
       SUBSTR(DECODE(lck.type, 'TM', obj.object_name, NULL), 1, 30) LOCK_ON
  FROM dba_objects obj,
       v$session   ses,
       v$lock      lck
 WHERE ses.sid = lck.sid
   AND lck.type IN ('RW', 'TM', 'TX', 'UL')      
   AND lck.id1 = obj.object_id(+)
 ORDER BY 1,2;
 -- ORDER BY username;


