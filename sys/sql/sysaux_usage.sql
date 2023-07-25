--
-- $Header: /jbs/var/cvs/orascripts/sql/sysaux_usage.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
--
-- Display sysaux contents
--
SELECT occupant_name AS name,
occupant_desc,
schema_name AS schema,
Decode (move_procedure_desc, '*** MOVE PROCEDURE NOT APPLICABLE ***','N',
'Y') AS Moveable,
space_usage_kbytes/1024 AS space_in_mb
FROM V$SYSAUX_OCCUPANTS
ORDER BY 3;
