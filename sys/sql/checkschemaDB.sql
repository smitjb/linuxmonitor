set pagesize 999
set verify off feedback off

column a new_value user1  noprint 
column b new_value user2  noprint 
column c new_value dblink noprint 

column objects             heading "objects"             format a50
column synonym_name        heading "synonym_name"        format a30
column constraint_name     heading "constraint_name"     format a20
column constraint_type     heading "constraint_type"     format a10
column column_name         heading "column_name"         format a25
column status              heading "status"              format a10
column deferrable          heading "deferrable"          format a15
column deferred            heading "deferred"            format a25
column column_name         heading "column_name"         format a25
column index_type          heading "index_type"          format a10
column index_name          heading "index_name"          format a20
column table_name          heading "table_name"          format a25

column data_type           heading "data_type"          format a10
column data_scale          heading "data_scale"         format a5
column data_length         heading "data_length"        format a6
column precision           heading "precision"          format a9
column nullable            heading "nullable"           format a9

select upper('&1') a from dual;
select upper('&2') b from dual;
select upper('&3') c from dual;

column dblink noprint 
column objects  a30

--select decode(c,'','','@'||c) c from dual;

break on table_name

prompt *********************************************************************************************
prompt 		Objects in &USER1 	that are missing from &USER2 @ &dblink
prompt *********************************************************************************************
prompt                                                                                              

select substr(object_name||' '||substr(object_type,1,15),1,30) objects
from dba_objects
where owner = '&USER1'
minus
select substr(object_name||' '||substr(object_type,1,15),1,30) objects
from dba_objects@&dblink
where owner = '&USER2' 
/

prompt *********************************************************************************************
prompt  		Objects in &USER2 &dblink 	that are missing from &USER1                 
prompt *********************************************************************************************
prompt                                                                                              

select substr(object_name||' '||substr(object_type,1,15),1,30) objects
from dba_objects@&dblink
where owner = '&USER2' 
minus
select substr(object_name||' '||substr(object_type,1,15),1,30) objects
from dba_objects
where owner = '&USER1'
/

prompt *********************************************************************************************
prompt                 Synonyms in &USER1       that are missing from &USER2 @ &dblink
prompt *********************************************************************************************
prompt                                                                                              

select synonym_name
from   dba_synonyms
where  owner = '&USER1'
minus
select synonym_name
from   dba_synonyms@&dblink
where  owner = '&USER2' 
/

prompt *********************************************************************************************
prompt                 Synonyms in &USER2' &dblink       that are missing from &USER1
prompt *********************************************************************************************
prompt                                                                                              

select synonym_name
from   dba_synonyms@&dblink
where  owner = '&USER2' 
minus
select synonym_name
from   dba_synonyms
where  owner = '&USER1'
/

prompt *********************************************************************************************
prompt  		Constraints in &USER1 	that are missing from &USER2 @ &dblink 
prompt *********************************************************************************************
prompt                                                                                              

select substr(a.table_name,1,25) table_name,
       substr(a.constraint_name,1,20) constraint_name,
       substr(a.constraint_type,1,10) constraint_type,
       substr(b.column_name,1,25) column_name,
       a.status,
       a.deferrable,
       substr(a.deferred,1,20) deferred
from   dba_constraints   a,
       dba_cons_columns  b
where  a.constraint_type  in ('P','R','U')
and    a.owner           = '&USER1'
and    b.owner           = '&USER1'
and    a.table_name      = b.table_name
and    a.constraint_name = b.constraint_name
minus
select substr(a.table_name,1,25) table_name,
       substr(a.constraint_name,1,20) constraint_name,
       substr(a.constraint_type,1,10) constraint_type,
       substr(b.column_name,1,25) column_name,
       a.status,
       a.deferrable,
       substr(a.deferred,1,20) deferred
from   dba_constraints@&dblink   a,
       dba_cons_columns@&dblink  b
where  a.constraint_type  in ('P','R','U')
and    a.owner           = '&USER2' 
and    b.owner           = '&USER2' 
and    a.table_name      = b.table_name
and    a.constraint_name = b.constraint_name
/

prompt *********************************************************************************************
prompt  		Constraints in &USER2' &dblink 	that are missing from &USER1 
prompt *********************************************************************************************
prompt                                                                                              

select substr(a.table_name,1,25) table_name,
       substr(a.constraint_name,1,20) constraint_name,
       substr(a.constraint_type,1,10) constraint_type,
       substr(b.column_name,1,25) column_name,
       a.status,
       a.deferrable,
       substr(a.deferred,1,20) deferred
from   dba_constraints@&dblink   a,
       dba_cons_columns@&dblink  b
where  a.constraint_type  in ('P','R','U')
and    a.owner           = '&USER2' 
and    b.owner           = '&USER2' 
and    a.table_name      = b.table_name
and    a.constraint_name = b.constraint_name
minus
select substr(a.table_name,1,25) table_name,
       substr(a.constraint_name,1,20) constraint_name,
       substr(a.constraint_type,1,10) constraint_type,
       substr(b.column_name,1,25) column_name,
       a.status,
       a.deferrable,
       substr(a.deferred,1,20) deferred
from   dba_constraints   a,
       dba_cons_columns  b
where  a.constraint_type  in ('P','R','U')
and    a.owner           = '&USER1'
and    b.owner           = '&USER1'
and    a.table_name      = b.table_name
and    a.constraint_name = b.constraint_name
/

prompt *********************************************************************************************
prompt  		Indexes in &USER1 	that are missing from &USER2 @ &dblink
prompt *********************************************************************************************
prompt                                                                                              

select substr(a.table_name,1,25) table_name,
       substr(a.index_name,1,25) index_name,
       substr(b.column_name,1,25) column_name,
       a.uniqueness,
       substr(a.index_type,1,10) index_type
from   dba_indexes     a,
       dba_ind_columns b
where  owner='&USER1'
and    a.index_name = b.index_name
and    a.table_name = b.table_name
minus
select substr(a.table_name,1,25) table_name,
       substr(a.index_name,1,25) index_name,
       substr(b.column_name,1,25) column_name,
       a.uniqueness,
       substr(a.index_type,1,10) index_type
from   dba_indexes@&dblink     a,
       dba_ind_columns@&dblink b
where  owner='&USER2' 
and    a.index_name = b.index_name
and    a.table_name = b.table_name;


prompt *********************************************************************************************
prompt  		Indexes in &USER2' &dblink 	that are missing from &USER1 
prompt *********************************************************************************************
prompt                                                                                              

select substr(a.table_name,1,25) table_name,
       substr(a.index_name,1,25) index_name,
       substr(b.column_name,1,25) column_name,
       a.uniqueness,
       substr(a.index_type,1,10) index_type
from   dba_indexes@&dblink     a,
       dba_ind_columns@&dblink b
where  owner='&USER2' 
and    a.index_name = b.index_name
and    a.table_name = b.table_name
minus
select substr(a.table_name,1,25) table_name,
       substr(a.index_name,1,25) index_name,
       substr(b.column_name,1,25) column_name,
       a.uniqueness,
       substr(a.index_type,1,10) index_type
from   dba_indexes     a,
       dba_ind_columns b
where  owner='&USER1'
and    a.index_name = b.index_name
and    a.table_name = b.table_name;

prompt *********************************************************************************************
prompt  		Sequences in &USER1 	that are missing from &USER2 @ &dblink 
prompt *********************************************************************************************
prompt                                                                                              

select sequence_name 
from dba_sequences
where sequence_owner='&USER1'
minus
select sequence_name 
from dba_sequences@&dblink
where sequence_owner='&USER2' 
/

prompt *********************************************************************************************
prompt  		Sequences in &USER2' &dblink 	that are missing from &USER1 
prompt *********************************************************************************************
prompt                                                                                              

select sequence_name 
from dba_sequences@&dblink
where sequence_owner='&USER2' 
minus
select sequence_name 
from dba_sequences
where sequence_owner='&USER1'
/

prompt *********************************************************************************************
prompt  		Table columns in &USER1 that differ to &USER2' &dblink 	
prompt *********************************************************************************************
prompt                                                                                              

select TABLE_NAME
      ,COLUMN_NAME
      ,substr(DATA_TYPE,1,10)     DATA_TYPE
      ,substr(DATA_LENGTH,1,6)    length
      ,substr(DATA_PRECISION,1,9) precision
      ,substr(DATA_SCALE,1,5)     scale
      ,substr(decode(NULLABLE,'Y','NULL','N','NOT NULL'),1,8) nullable
from dba_tab_columns
where owner='&USER1'
minus
select TABLE_NAME
      ,COLUMN_NAME
      ,substr(DATA_TYPE,1,10)     DATA_TYPE
      ,substr(DATA_LENGTH,1,6)    length
      ,substr(DATA_PRECISION,1,9) precision
      ,substr(DATA_SCALE,1,5)     scale
      ,substr(decode(NULLABLE,'Y','NULL','N','NOT NULL'),1,8) nullable
from dba_tab_columns@&dblink
where owner='&USER2' 
/

prompt *********************************************************************************************
prompt  		Table columns in &USER2' &dblink that differ to &USER1 
prompt *********************************************************************************************
prompt                                                                                              

select TABLE_NAME
      ,COLUMN_NAME
      ,substr(DATA_TYPE,1,10)     DATA_TYPE
      ,substr(DATA_LENGTH,1,6)    length
      ,substr(DATA_PRECISION,1,9) precision
      ,substr(DATA_SCALE,1,5)     scale
      ,substr(decode(NULLABLE,'Y','NULL','N','NOT NULL'),1,8) nullable
from dba_tab_columns@&dblink
where owner='&USER2' 
minus
select TABLE_NAME
      ,COLUMN_NAME
      ,substr(DATA_TYPE,1,10)     DATA_TYPE
      ,substr(DATA_LENGTH,1,6)    length
      ,substr(DATA_PRECISION,1,9) precision
      ,substr(DATA_SCALE,1,5)     scale
      ,substr(decode(NULLABLE,'Y','NULL','N','NOT NULL'),1,8) nullable
from dba_tab_columns
where owner='&USER1'
/



prompt *********************************************************************************************
prompt                  Triggers in &USER1 that differ to &USER2' &dblink
prompt *********************************************************************************************
prompt

select SUBSTR(table_name,1,30)        table_name
      ,SUBSTR(column_name,1,30)       column_name
      ,SUBSTR(trigger_name,1,30)      trigger_name
      ,SUBSTR(triggering_event,1,30)  triggering_event
      ,SUBSTR(action_type,1,10)       action_type 
      ,SUBSTR(status,1,10)            status 
from   dba_triggers
where owner='&USER1'
minus
select SUBSTR(table_name,1,30)        table_name
      ,SUBSTR(column_name,1,30)       column_name
      ,SUBSTR(trigger_name,1,30)      trigger_name
      ,SUBSTR(triggering_event,1,30)  triggering_event
      ,SUBSTR(action_type,1,10)       action_type
      ,SUBSTR(status,1,10)            status
from   dba_triggers@&dblink
where owner='&USER2'
order by trigger_name;


prompt *********************************************************************************************
prompt                  Triggers in &USER2 that differ to &USER1' &dblink
prompt *********************************************************************************************
prompt

select SUBSTR(table_name,1,30)        table_name
      ,SUBSTR(column_name,1,30)       column_name
      ,SUBSTR(trigger_name,1,30)      trigger_name
      ,SUBSTR(triggering_event,1,30)  triggering_event
      ,SUBSTR(action_type,1,10)       action_type
      ,SUBSTR(status,1,10)            status
from   dba_triggers@&dblink
where owner='&USER2'
minus
select SUBSTR(table_name,1,30)        table_name
      ,SUBSTR(column_name,1,30)       column_name
      ,SUBSTR(trigger_name,1,30)      trigger_name
      ,SUBSTR(triggering_event,1,30)  triggering_event
      ,SUBSTR(action_type,1,10)       action_type
      ,SUBSTR(status,1,10)            status
from   dba_triggers
where owner='&USER1'
order by trigger_name;



break on wind
set pagesize 0
set verify on feedback on
