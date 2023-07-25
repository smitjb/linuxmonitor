col seqno  format 999 noprint

SPOOL rmdatabase.lis

SELECT 1                               seqno,
       'rm ' || SUBSTR(name,1,70)      filename
FROM v$controlfile
UNION
SELECT 2                               seqno,
       'rm ' || SUBSTR(member,1,80)    filename
FROM   v$logfile
UNION
SELECT 3                               seqno,
       'rm ' || SUBSTR(FILE_NAME,1,80) filename
FROM   dba_data_files
UNION
SELECT 4                                   seqno,
       'rm ' || SUBSTR(value,1,50) || '/*' filename
FROM   sys.v_$parameter
WHERE  name IN ('audit_file_dest','background_dump_dest','core_dump_dest','user_dump_dest')
UNION
SELECT 5                                                            seqno,
       'rm /u01/oradata/' || SUBSTR(LOWER(global_name),1,7) || '/*' filename
FROM   global_name
UNION
SELECT 6                                                            seqno,
       'rm /u02/oradata/' || SUBSTR(LOWER(global_name),1,7) || '/*' filename
FROM   global_name
UNION
SELECT 7                                                            seqno,
       'rm /u03/oradata/' || SUBSTR(LOWER(global_name),1,7) || '/*' filename
FROM   global_name
UNION
SELECT 8                                                            seqno,
       'rm /u04/oradata/' || SUBSTR(LOWER(global_name),1,7) || '/*' filename
FROM   global_name
UNION
SELECT 9                                                            seqno,
       'rm /u05/oradata/' || SUBSTR(LOWER(global_name),1,7) || '/*' filename
FROM   global_name
UNION
SELECT 10                                                           seqno,
       'rm /u06/oradata/' || SUBSTR(LOWER(global_name),1,7) || '/*' filename
FROM   global_name
UNION
SELECT 11                                                           seqno,
       'rm /u07/oradata/' || SUBSTR(LOWER(global_name),1,7) || '/*' filename
FROM   global_name
UNION
SELECT 12                                                           seqno,
       'rm /u09/oradata/' || SUBSTR(LOWER(global_name),1,7) || '/*' filename
FROM   global_name
UNION
SELECT 13                                                                            seqno,
       'rm /u01/app/oracle/admin/' || SUBSTR(LOWER(global_name),1,7) || '/archive/*' filename
FROM   global_name
UNION
SELECT 13                                                                            seqno,
       'rm /u01/app/oracle/admin/' || SUBSTR(LOWER(global_name),1,7) || '/exp/*'     filename
FROM   global_name
UNION
SELECT 13                                                                            seqno,
       'rm /u01/app/oracle/admin/' || SUBSTR(LOWER(global_name),1,7) || '/pfile/*'   filename
FROM   global_name
ORDER BY seqno, filename;

SPOOL OFF

PROMPT .
PROMPT Now run dropDB.sql
PROMPT .
