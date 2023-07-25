set linesize 1000
col name format a15
col queue_table format a15
col enqueue_enabled format a10
col dequeue_enabled format a10
col user_comment format a10
select owner,name,queue_table,enqueue_enabled,dequeue_enabled,user_comment from dba_queues
/