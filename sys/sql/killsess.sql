-- #########################################################
-- # Name    : killsess.sql
-- # Author  : Des Fox
-- # Date    : November 2001
-- # Purpose : Compile schema objects.
-- # Calling routines : None
-- # Called  routines : None
-- # Notes   : connect as sys
-- # Usage   : @killsess.sql
-- # 
-- # Modified
-- # By        Date     Reason
-- # ========= ======== ====================================
-- # 
-- #########################################################

SET LINESIZE  120 
SET PAGES     1000 
SET FEEDBACK  OFF 
SET HEADING   OFF

SPOOL kill_sessions.sql

SELECT 'ALTER SYSTEM KILL SESSION ''' || s.sid || ',' || s.serial# || ''';' || '   ' || '               '
FROM   v$process p, 
       v$session s
WHERE  p.addr = s.paddr
AND    SUBSTR(NVL(s.program, p.program),1,35) NOT LIKE '%SNP%'
AND    s.username NOT IN ('SYS','SYSTEM')
AND    s.username IS NOT NULL
AND    s.type != 'BACKGROUND'
ORDER BY s.username, 
         s.sid;

SPOOL OFF

SET LINESIZE  120 
SET PAGES     1000 
SET FEEDBACK  ON 
SET HEADING   ON

SELECT 'ALTER SYSTEM KILL SESSION ''' || s.sid || ',' || s.serial# || ''';' || '   ' || '               ' ||
       LPAD(s.username,40,' ') "Session info by user"
FROM   v$process p,
       v$session s
WHERE  p.addr = s.paddr
AND    SUBSTR(NVL(s.program, p.program),1,35) NOT LIKE '%SNP%'
AND    s.username NOT IN ('SYS','SYSTEM')
AND    s.username IS NOT NULL
AND    s.type != 'BACKGROUND'
ORDER BY s.username,
         s.sid;

PROMPT .
PROMPT Now edit and run @kill_sessions.sql
PROMPT .

