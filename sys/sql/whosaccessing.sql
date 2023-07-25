SELECT vs.username "User", vs.machine "Client Host",
vs.sid "DB SID", vs.serial# "DB Serial #", vs.program "Program",
vs.action "Action", to_char(vs.logon_time,'MM/DD/YYYY HH24:MI') "Login Time",
vp.spid "Server Process"
FROM v$session vs, v$process vp, v$access va
WHERE vp.addr(+) = vs.paddr
AND vs.sid = va.sid
AND va.object = upper('&&1')