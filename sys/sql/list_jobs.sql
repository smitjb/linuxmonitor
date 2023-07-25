--
-- $Header: /jbs/var/cvs/orascripts/sql/list_jobs.sql,v 1.1 2013/01/02 15:17:35 jim Exp $
--
-- 
-- $Log: list_jobs.sql,v $
-- Revision 1.1  2013/01/02 15:17:35  jim
-- Migrated from utils
--
-- Revision 1.1.1.1  2005/11/27 10:10:21  jim
-- Migrated from client sight
--
-- Revision 1.1  2005/08/08 09:50:46  jim.smith
-- New reporting scripts
--
--
--
-- =======================================================================
column job_name format a40
select 	job,
	et_name||':'||ej_name job_name,
	last_date,this_date,next_date,
	broken,failures
from elx_tasks,elx_jobs,user_jobs
where ej_task_id=et_id
and job=ej_oracle_job_no
/
