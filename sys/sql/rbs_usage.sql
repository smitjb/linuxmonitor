COLUMN  name FORMAT a10         HEADING "Rollback|Segment"
COLUMN  sid  FORMAT 99999       HEADING "Oracle|PID"
COLUMN  spid FORMAT 99999       HEADING "Sys|PID"
COLUMN  curext FORMAT 999999    HEADING "Current|Extent"
COLUMN  curblk FORMAT 999999    HEADING "Current|Block"
COLUMN transaction FORMAT A15   Heading 'Transaction'
COLUMN program FORMAT a30 HEADING 'Program'
SET PAGES 56  LINES 150 VERIFY OFF 
SELECT
     r.name, l.Sid, p.spid,
     NVL(p.username, 'no transaction') "Transaction",
     p.program "Program",
     s.curext,s.curblk
FROM
     v$lock l,
     v$process p,
     v$rollname r,
     v$rollstat s
WHERE
         l.Sid = p.pid (+)
     AND TRUNC(l.id1(+) / 65536) = r.usn
     AND l.type(+) = 'TX'
     AND l.lmode(+) = 6
     AND r.usn=s.usn
     AND p.username is not null
ORDER BY r.name;


