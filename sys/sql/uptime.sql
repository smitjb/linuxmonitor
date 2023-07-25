--
-- $Header: /jbs/var/cvs/orascripts/sql/uptime.sql,v 1.1.1.1 2012/12/28 17:34:14 jim Exp $
-- show database uptime 

select sysdate-startup_time days from v$instance;
