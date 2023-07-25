set linesize 178
set pages    2000

column   OBJ#                                  format 999999 
column   DATAOBJ#                              format 999999
column   OWNER#                                format 999999
column   project     heading ""                format a2
column   user_name   heading "User"            format a15 
column   obj_name    heading "Object Name"     format a30 
column   TYPE#                                 format 9999
column   typedesc    heading "Typ"             format a3 
column   CTIME       heading "Created Date"    format a15 
column   MTIME       heading "Modified Date"   format a15 
column   status_desc heading "Status"          format a10

SELECT 'NG'                                     project,
       TO_CHAR(a.mtime,'DDMMYY HH24:MI:SS')     mtime,
       a.name                                   obj_name,
       DECODE(a.type#,1,'Ind',
                      2,'Tab',
                      4,'Vw',
                      5,'Syn',
                      6,'Seq',
                     12,'Trg', 
                     21,'LOB', 
                      a.type#)                  typedesc,
       TO_CHAR(a.ctime,'DDMMYY HH24:MI:SS')   ctime,
       DECODE(a.status, 1, ' VALID',
                        5, ' INVALID',
                        a.status)               status_desc,
       b.name                                   user_name
FROM   sys.obj$   a,
       sys.user$  b
WHERE  a.owner# = b.user#
AND    b.name   = UPPER('&&1')    
ORDER BY a.mtime  DESC
/
