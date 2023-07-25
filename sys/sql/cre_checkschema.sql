SET serveroutput ON SIZE 1000000
SET LINESIZE 220

-- #############################################################################
-- # Name   : p_checkschema
-- # Author : Des Fox      
-- # Date   : Jan 2003
-- # Purpose: 
-- #         
-- #        
-- # Calling routine:
-- # Called routine:
-- # Parameter files:
-- # Notes  : Requires the following grants to be in place issued by SYS:
-- # 
-- #          GRANT SELECT ON DBA_TABLES              TO CRUISE;
-- #          GRANT SELECT ON DBA_OBJECTS             TO CRUISE;
-- #          GRANT SELECT ON DBA_SYNONYMS            TO CRUISE;
-- #          GRANT SELECT ON DBA_TABLES              TO CRUISE;
-- #          GRANT SELECT ON DBA_CONSTRAINTS         TO CRUISE;
-- #          GRANT SELECT ON DBA_INDEXES             TO CRUISE;
-- #          GRANT SELECT ON DBA_SEQUENCES           TO CRUISE;
-- #
-- # Usage  : 
-- # Modified:
-- # By          When     Change
-- # ----------- -------- ------------------------------------------------------
-- #          
-- #############################################################################


CREATE OR REPLACE PROCEDURE p_checkschema (p_filename     IN VARCHAR2,
                                           p_path         IN VARCHAR2,
                                           p_username_1   IN VARCHAR2,
                                           p_username_2   IN VARCHAR2 )   AS
  v_filename      VARCHAR2(50);
  v_output_file   UTL_FILE.file_type;
  v_path          VARCHAR2(50);
  v_no_rows       VARCHAR2(40);
  v_text          VARCHAR2(150);
  v_diffs_found   VARCHAR2(2);
  v_date          DATE;
  v_header_1      VARCHAR2(80);
  v_header_2      VARCHAR2(80);
  v_header_3      VARCHAR2(80);
  v_header_4      VARCHAR2(80);

  v_cursor_id     NUMBER;
  v_sql           LONG;
  v_num_rows      INTEGER;
  v_count         NUMBER(10) := 1;

  v_user1         SYS.dba_tables.owner%TYPE;
  v_user2         SYS.dba_tables.owner%TYPE;
  v_dblink        SYS.dba_tables.table_name%TYPE;

  v_dummy         NUMBER; 
  v_object_type   SYS.dba_objects.object_type%TYPE;
  v_object_name   SYS.dba_objects.object_name%TYPE;
  v_synonym_name  SYS.dba_synonyms.synonym_name%TYPE;
  v_table_name    SYS.dba_tables.table_name%TYPE;

  v_column_name      VARCHAR2(30);
  v_data_type        VARCHAR2(10);
  v_data_length      VARCHAR2(6);
  v_data_precision   VARCHAR2(9);
  v_data_scale       VARCHAR2(5);
  v_nullable         VARCHAR2(8);

  v_constraint_name  SYS.dba_constraints.constraint_name%TYPE;
  v_constraint_type  SYS.dba_constraints.constraint_type%TYPE;
  v_status           SYS.dba_constraints.status%TYPE;
  v_deferrable       SYS.dba_constraints.deferrable%TYPE;
  v_deferred         SYS.dba_constraints.deferred%TYPE;

  v_index_name       SYS.dba_indexes.index_name%TYPE;
  v_uniqueness       SYS.dba_indexes.uniqueness%TYPE;
  v_index_type       SYS.dba_indexes.index_type%TYPE;

  v_sequence_name    SYS.dba_sequences.sequence_name%TYPE;

BEGIN
  
  v_filename    := p_filename;
  v_path        := p_path;
  v_user1       := p_username_1;
  v_user2       := p_username_2;

  v_output_file := UTL_FILE.fopen(v_path, v_filename, 'W');
  v_diffs_found := 'N'; -- set to Y where diffs detected.

  SELECT SYSDATE
  INTO   v_date
  FROM   dual;

  v_header_1 := '____________________________________________________________________   ';
  v_header_2 := 'Date : ' || SUBSTR(TO_CHAR(v_date,'DD-MON-YYYY HH24:MI:SS'),1,20) || '.';
  v_header_3 := 'Comparing schemas : ' || v_user1 || ' and ' || v_user2 || '.';
  v_header_4 := ' ';

  UTL_FILE.putf(v_output_file, v_header_1||CHR(10));
  UTL_FILE.putf(v_output_file, v_header_2||CHR(10));
  UTL_FILE.putf(v_output_file, v_header_4||CHR(10));
  UTL_FILE.putf(v_output_file, v_header_3||CHR(10));
  UTL_FILE.putf(v_output_file, v_header_4||CHR(10));

  --
  -- Objects on Local side not on the DBlink side.
  --

  v_sql := ' SELECT SUBSTR(obs.object_name,1,30)  object_name,'            ||
           '        SUBSTR(obs.object_type,1,15)  object_type '            ||
           ' FROM   SYS.dba_objects  obs'                                  ||
           ' WHERE  obs.owner = '''                                        || v_user1  || '''' ||
           ' AND    NOT EXISTS (SELECT a.index_name'                       ||
           '                    FROM   SYS.dba_indexes     a,'             ||
           '                           SYS.dba_ind_columns b'              ||
           '                    WHERE  a.owner       = '''                 || v_user1  || '''' ||
           '                    AND    a.owner       = obs.owner'          ||
           '                    AND    a.index_name  = obs.object_name'    ||
           '                    AND    b.index_owner = obs.owner'          ||
           '                    AND    a.index_name  = b.index_name'       ||
           '                    AND    a.table_name  = b.table_name'       ||
           '                    AND   (a.table_name LIKE ''ADB%''  AND'    ||
           '                           a.index_name LIKE ''SYS%''))'       ||
           ' MINUS'                                                        ||
           ' SELECT SUBSTR(obs.object_name,1,30)  object_name,'            ||
           '        SUBSTR(obs.object_type,1,15)  object_type '            ||
           ' FROM   SYS.dba_objects  obs'                                  ||
           ' WHERE  obs.owner = '''                                        || v_user2  || '''' ||
           ' AND    NOT EXISTS (SELECT a.index_name'                       ||
           '                    FROM   SYS.dba_indexes     a,'             ||
           '                           SYS.dba_ind_columns b'              ||
           '                    WHERE  a.owner       = '''                 || v_user2  || '''' ||
           '                    AND    a.owner       = obs.owner'          ||
           '                    AND    a.index_name  = obs.object_name'    ||
           '                    AND    b.index_owner = obs.owner'          ||
           '                    AND    a.index_name  = b.index_name'       ||
           '                    AND    a.table_name  = b.table_name'       ||
           '                    AND   (a.table_name LIKE ''ADB%''  AND'    ||
           '                           a.index_name LIKE ''SYS%''))'; 

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_object_name,50);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_object_type,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Objects in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Objects in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_object_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_object_type);

      DBMS_OUTPUT.put_line(RPAD(v_object_type,15,' ') || ' ' || v_object_name);
      v_text := RPAD(v_object_type,15,' ') || ' ' || v_object_name;
      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Objects on DBlink side not on Local side.
  --
 
  v_sql := ' SELECT SUBSTR(obs.object_name,1,30)  object_name,'            ||
           '        SUBSTR(obs.object_type,1,15)  object_type '            ||
           ' FROM   SYS.dba_objects  obs'                                  ||
           ' WHERE  obs.owner = '''                                        || v_user2  || '''' ||
           ' AND    NOT EXISTS (SELECT a.index_name'                       ||
           '                    FROM   SYS.dba_indexes     a,'             ||
           '                           SYS.dba_ind_columns b'              ||
           '                    WHERE  a.owner       = '''                 || v_user2  || '''' ||
           '                    AND    a.owner       = obs.owner'          ||
           '                    AND    a.index_name  = obs.object_name'    ||
           '                    AND    b.index_owner = obs.owner'          ||
           '                    AND    a.index_name  = b.index_name'       ||
           '                    AND    a.table_name  = b.table_name'       ||
           '                    AND   (a.table_name LIKE ''ADB%''  AND'    ||
           '                           a.index_name LIKE ''SYS%''))'       ||
           ' MINUS'                                                        ||
           ' SELECT SUBSTR(obs.object_name,1,30)  object_name,'            ||
           '        SUBSTR(obs.object_type,1,15)  object_type '            ||
           ' FROM   SYS.dba_objects  obs'                                  ||
           ' WHERE  obs.owner = '''                                        || v_user1  || '''' ||
           ' AND    NOT EXISTS (SELECT a.index_name'                       ||
           '                    FROM   SYS.dba_indexes     a,'             ||
           '                           SYS.dba_ind_columns b'              ||
           '                    WHERE  a.owner       = '''                 || v_user1  || '''' ||
           '                    AND    a.owner       = obs.owner'          ||
           '                    AND    a.index_name  = obs.object_name'    ||
           '                    AND    b.index_owner = obs.owner'          ||
           '                    AND    a.index_name  = b.index_name'       ||
           '                    AND    a.table_name  = b.table_name'       ||
           '                    AND   (a.table_name LIKE ''ADB%''  AND'    ||
           '                           a.index_name LIKE ''SYS%''))'; 
 
  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_object_name,50);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_object_type,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);
  
  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;
     
      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Objects in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Objects in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_object_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_object_type);

      DBMS_OUTPUT.put_line(RPAD(v_object_type,15,' ') || ' ' || v_object_name);
      v_text := RPAD(v_object_type,15,' ') || ' ' || v_object_name;
      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;  

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Synonyms on Local side not on the DBlink side.
  --

  v_sql := 'SELECT  synonym_name '                          ||
           ' FROM   SYS.dba_synonyms '                          ||
           ' WHERE  owner = '''                             || v_user1  || '''' ||
           ' MINUS '                                        ||
           ' SELECT synonym_name '                          ||
           ' FROM   SYS.dba_synonyms '                          || 
           ' WHERE  owner = '''                             || v_user2  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_synonym_name,40);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Synonyms in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Synonyms in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_synonym_name);

      DBMS_OUTPUT.put_line(v_synonym_name);
      v_text := v_synonym_name;
      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Synonyms on DBlink side not on the Local side.
  --

  v_sql := 'SELECT  synonym_name '                          ||
           ' FROM   SYS.dba_synonyms '                          || 
           ' WHERE  owner = '''                             || v_user2  || '''' ||
           ' MINUS '                                        ||
           ' SELECT synonym_name '                          ||
           ' FROM   SYS.dba_synonyms '                          ||
           ' WHERE  owner = '''                             || v_user1  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_synonym_name,40);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Synonyms in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Synonyms in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_synonym_name);

      DBMS_OUTPUT.put_line(v_synonym_name);
      v_text := v_synonym_name;
      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Tables on Local side not on the DBlink side.
  --

  v_sql := 'SELECT  table_name '                            ||
           ' FROM   SYS.dba_tables '                            ||
           ' WHERE  owner = '''                             || v_user1  || '''' ||
           ' MINUS '                                        ||
           ' SELECT table_name '                            ||
           ' FROM   SYS.dba_tables '                            || 
           ' WHERE  owner = '''                             || v_user2  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Tables in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Tables in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);

      DBMS_OUTPUT.put_line(v_table_name);
      v_text := v_table_name;
      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Tables on DBlink side not on the local side.
  --

  v_sql := 'SELECT  table_name '                            ||
           ' FROM   SYS.dba_tables '                            || 
           ' WHERE  owner = '''                             || v_user2  || '''' ||
           ' MINUS '                                        ||
           ' SELECT table_name '                            ||
           ' FROM   SYS.dba_tables '                            || 
           ' WHERE  owner = '''                             || v_user1  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Tables in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Tables in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);

      DBMS_OUTPUT.put_line(v_table_name);
      v_text := v_table_name;
      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);


  --
  -- Table columns on Local side not on the DBlink side.
  --

  v_sql := 'SELECT  SUBSTR(table_name,1,30)    table_name, '                    ||
           '        SUBSTR(column_name,1,30)   column_name, '                   ||
           '        SUBSTR(data_type,1,10)     data_type, '                     ||
           '        SUBSTR(data_length,1,6)    length,    '                     ||
           '        SUBSTR(data_precision,1,9) precision, '                     ||
           '        SUBSTR(data_scale,1,5)     scale,     '                     ||
           ' SUBSTR(DECODE(nullable,''Y'',''NULL'',''N'',''NOT NULL''),1,8) nullable '  ||
           ' FROM   SYS.dba_tab_columns '                       			||
           ' WHERE  owner = '''                             			|| v_user1  || '''' ||
           ' MINUS '                                        			||
           ' SELECT SUBSTR(table_name,1,30)    table_name, '      		||
           '        SUBSTR(column_name,1,30)   column_name, '                   ||
           '        SUBSTR(data_type,1,10)     data_type, '                     ||
           '        SUBSTR(data_length,1,6)    length,    '                     ||
           '        SUBSTR(data_precision,1,9) precision, '                     ||
           '        SUBSTR(data_scale,1,5)     scale,     '                     ||
           ' SUBSTR(DECODE(nullable,''Y'',''NULL'',''N'',''NOT NULL''),1,8) nullable '  ||
           ' FROM   SYS.dba_tab_columns '                          			|| 
           ' WHERE  owner = '''                             			|| v_user2  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,30);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_column_name,30);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,3,v_data_type,12);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,4,v_data_length,7);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,5,v_data_precision,12);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,6,v_data_scale,6);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,7,v_nullable,9);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Table columns in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Table columns in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_column_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,3,v_data_type);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,4,v_data_length);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,5,v_data_precision);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,6,v_data_scale);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,7,v_nullable);

      DBMS_OUTPUT.put_line(RPAD(v_table_name,30,' ')     || ' '   || 
                           RPAD(v_column_name,30,' ')    || ' '   ||
                           RPAD(v_data_type,12,' ')      || ' ( ' ||
                           RPAD(v_data_length,7,' ')     || ' ) ' ||
                           RPAD(v_nullable,9,' ')        || ' '   ||
                           RPAD(v_data_precision,12,' ') || ' '   ||
                           RPAD(v_data_scale,6,' '));

      v_text := RPAD(v_table_name,30,' ')     || ' '   ||
                RPAD(v_column_name,30,' ')    || ' '   ||
                RPAD(v_data_type,12,' ')      || ' ( ' ||
                RPAD(v_data_length,7,' ')     || ' ) ' ||
                RPAD(v_nullable,9,' ')        || ' '   ||
                RPAD(v_data_precision,12,' ') || ' '   ||
                RPAD(v_data_scale,6,' ');

      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Table columns on DBlink sude not on Local side.
  --

  v_sql := 'SELECT  SUBSTR(table_name,1,30)    table_name, '                    ||
           '        SUBSTR(column_name,1,30)   column_name, '                   ||
           '        SUBSTR(data_type,1,10)     data_type, '                     ||
           '        SUBSTR(data_length,1,6)    length,    '                     ||
           '        SUBSTR(data_precision,1,9) precision, '                     ||
           '        SUBSTR(data_scale,1,5)     scale,     '                     ||
           ' SUBSTR(DECODE(nullable,''Y'',''NULL'',''N'',''NOT NULL''),1,8) nullable '  ||
           ' FROM   SYS.dba_tab_columns '                                           || 
           ' WHERE  owner = '''                                                 || v_user2  || '''' ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(table_name,1,30)    table_name, '                    ||
           '        SUBSTR(column_name,1,30)   column_name, '                   ||
           '        SUBSTR(data_type,1,10)     data_type, '                     ||
           '        SUBSTR(data_length,1,6)    length,    '                     ||
           '        SUBSTR(data_precision,1,9) precision, '                     ||
           '        SUBSTR(data_scale,1,5)     scale,     '                     ||
           ' SUBSTR(DECODE(nullable,''Y'',''NULL'',''N'',''NOT NULL''),1,8) nullable '  ||
           ' FROM   SYS.dba_tab_columns '                                           || 
           ' WHERE  owner = '''                                                 || v_user1  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,30);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_column_name,30);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,3,v_data_type,12);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,4,v_data_length,7);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,5,v_data_precision,12);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,6,v_data_scale,6);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,7,v_nullable,9);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Table columns in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         v_count := 0;
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Table columns in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_column_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,3,v_data_type);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,4,v_data_length);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,5,v_data_precision);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,6,v_data_scale);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,7,v_nullable);

      DBMS_OUTPUT.put_line(RPAD(v_table_name,30,' ')     || ' '   ||
                           RPAD(v_column_name,30,' ')    || ' '   ||
                           RPAD(v_data_type,12,' ')      || ' ( ' ||
                           RPAD(v_data_length,7,' ')     || ' ) ' ||
                           RPAD(v_nullable,9,' ')        || ' '   ||
                           RPAD(v_data_precision,12,' ') || ' '   ||
                           RPAD(v_data_scale,6,' '));

      v_text := RPAD(v_table_name,30,' ')     || ' '   ||
                RPAD(v_column_name,30,' ')    || ' '   ||
                RPAD(v_data_type,12,' ')      || ' ( ' ||
                RPAD(v_data_length,7,' ')     || ' ) ' ||
                RPAD(v_nullable,9,' ')        || ' '   ||
                RPAD(v_data_precision,12,' ') || ' '   ||
                RPAD(v_data_scale,6,' ');

      UTL_FILE.put_line   (v_output_file, v_text);


  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Local constraint columns not on the DBlink side.
  --

  v_sql := 'SELECT  SUBSTR(a.table_name,1,30) table_name,           '           ||
           '        SUBSTR(a.constraint_name,1,20) constraint_name, '           ||
           '        SUBSTR(a.constraint_type,1,10) constraint_type, '           ||
           '        SUBSTR(b.column_name,1,25) column_name,         '           ||
           '        a.status,     '                                             ||
           '        a.deferrable, '                                             ||
           '        SUBSTR(a.deferred,1,20) deferred  '                         ||
           ' FROM   SYS.dba_constraints   a, '                                  ||
           '        SYS.dba_cons_columns  b  '                                  ||
           ' WHERE  a.constraint_type  in (''P'',''R'',''U'')  '                ||
           ' AND    a.owner = '''                                               || v_user1  || '''' ||
           ' AND    a.owner = b.owner '                                         || 
           ' AND    a.table_name      = b.table_name      '                     ||
           ' AND    a.constraint_name = b.constraint_name '                     ||
           ' AND  ((a.table_name      NOT LIKE ''ADB%''  AND '                  ||
           '        a.constraint_name     LIKE ''SYS%'') '                      ||
           '      OR '                                                          ||
           '       (a.constraint_name NOT LIKE ''SYS%'')) '                     ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(a.table_name,1,25) table_name,           '           ||
           '        SUBSTR(a.constraint_name,1,20) constraint_name, '           ||
           '        SUBSTR(a.constraint_type,1,10) constraint_type, '           ||
           '        SUBSTR(b.column_name,1,25) column_name,         '           ||
           '        a.status,     '                                             ||
           '        a.deferrable, '                                             ||
           '        SUBSTR(a.deferred,1,20) deferred  '                         ||
           ' FROM   SYS.dba_constraints  a, '                                   || 
           '        SYS.dba_cons_columns b  '                                   || 
           ' WHERE  a.constraint_type  in (''P'',''R'',''U'')  '                ||
           ' AND    a.owner = '''                                               || v_user2  || '''' ||
           ' AND    a.owner = b.owner '                                         || 
           ' AND    a.table_name      = b.table_name      '                     ||
           ' AND    a.constraint_name = b.constraint_name '                     ||
           ' AND  ((a.table_name      NOT LIKE ''ADB%''  AND '                  ||
           '        a.constraint_name     LIKE ''SYS%'') '                      ||
           '      OR '                                                          ||
           '       (a.constraint_name NOT LIKE ''SYS%''))';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,30);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_constraint_name,20);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,3,v_constraint_type,10);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,4,v_column_name,25);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,5,v_status,8);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,6,v_deferrable,20);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,7,v_deferred,20);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Constraint columns in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Constraint columns in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;
      
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_constraint_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,3,v_constraint_type);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,4,v_column_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,5,v_status);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,6,v_deferrable);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,7,v_deferred);


      DBMS_OUTPUT.put_line(RPAD(v_table_name,30,' ')       || ' ' ||
                           RPAD(v_constraint_name,20,' ')  || ' ' ||
                           RPAD(v_constraint_type,10,' ')  || ' ' ||
                           RPAD(v_column_name,25,' ')      || ' ' ||
                           RPAD(v_status,8,' ')            || ' ' ||
                           RPAD(v_deferrable,20,' ')       || ' ' ||
                           RPAD(v_deferred,20,' '));

      v_text := RPAD(v_table_name,30,' ')       || ' ' ||
                RPAD(v_constraint_name,20,' ')  || ' ' ||
                RPAD(v_constraint_type,10,' ')  || ' ' ||
                RPAD(v_column_name,25,' ')      || ' ' ||
                RPAD(v_status,8,' ')            || ' ' ||
                RPAD(v_deferrable,20,' ')       || ' ' ||
                RPAD(v_deferred,20,' ');

      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- DB link constraint columns not on the local side.
  --

  v_sql := 'SELECT  SUBSTR(a.table_name,1,30) table_name,           '           ||
           '        SUBSTR(a.constraint_name,1,20) constraint_name, '           ||
           '        SUBSTR(a.constraint_type,1,10) constraint_type, '           ||
           '        SUBSTR(b.column_name,1,25) column_name,         '           ||
           '        a.status,     '                                             ||
           '        a.deferrable, '                                             ||
           '        SUBSTR(a.deferred,1,20) deferred  '                         ||
           ' FROM   SYS.dba_constraints  a, ' 					||
           '        SYS.dba_cons_columns b  ' 					||
           ' WHERE  a.constraint_type  in (''P'',''R'',''U'')  '                ||
           ' AND    a.owner = '''                                               || v_user2  || '''' ||
           ' AND    a.owner = b.owner '                                         ||                                     
           ' AND    a.table_name      = b.table_name      '                     ||
           ' AND    a.constraint_name = b.constraint_name '                     ||
           ' AND  ((a.table_name      NOT LIKE ''ADB%''  AND '                  ||
           '        a.constraint_name     LIKE ''SYS%'') '                      ||
           '      OR '                                                          ||
           '       (a.constraint_name NOT LIKE ''SYS%'')) '                     ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(a.table_name,1,25) table_name,           '           ||
           '        SUBSTR(a.constraint_name,1,20) constraint_name, '           ||
           '        SUBSTR(a.constraint_type,1,10) constraint_type, '           ||
           '        SUBSTR(b.column_name,1,25) column_name,         '           ||
           '        a.status,     '                                             ||
           '        a.deferrable, '                                             ||
           '        SUBSTR(a.deferred,1,20) deferred  '                         ||
           ' FROM   SYS.dba_constraints  a, '                                   || 
           '        SYS.dba_cons_columns b  '                                   || 
           ' WHERE  a.constraint_type  in (''P'',''R'',''U'')  '                ||
           ' AND    a.owner = '''                                               || v_user1  || '''' ||
           ' AND    a.owner = b.owner '                                         ||                             
           ' AND    a.table_name      = b.table_name      '                     ||
           ' AND    a.constraint_name = b.constraint_name '                     ||
           ' AND  ((a.table_name      NOT LIKE ''ADB%''  AND '                  ||
           '        a.constraint_name     LIKE ''SYS%'') '                      ||
           '      OR '                                                          ||
           '       (a.constraint_name NOT LIKE ''SYS%''))';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,30);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_constraint_name,20);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,3,v_constraint_type,10);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,4,v_column_name,25);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,5,v_status,8);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,6,v_deferrable,20);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,7,v_deferred,20);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Constraint columns in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Constraint columns in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_constraint_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,3,v_constraint_type);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,4,v_column_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,5,v_status);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,6,v_deferrable);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,7,v_deferred);


      DBMS_OUTPUT.put_line(RPAD(v_table_name,30,' ')       || ' ' ||
                           RPAD(v_constraint_name,20,' ')  || ' ' ||
                           RPAD(v_constraint_type,10,' ')  || ' ' ||
                           RPAD(v_column_name,25,' ')      || ' ' ||
                           RPAD(v_status,8,' ')            || ' ' ||
                           RPAD(v_deferrable,20,' ')       || ' ' ||
                           RPAD(v_deferred,20,' '));

      v_text := RPAD(v_table_name,30,' ')       || ' ' ||
                RPAD(v_constraint_name,20,' ')  || ' ' ||
                RPAD(v_constraint_type,10,' ')  || ' ' ||
                RPAD(v_column_name,25,' ')      || ' ' ||
                RPAD(v_status,8,' ')            || ' ' ||
                RPAD(v_deferrable,20,' ')       || ' ' ||
                RPAD(v_deferred,20,' ');

      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Local index columns not on the DBlink side.
  --

  v_sql := 'SELECT  SUBSTR(a.table_name,1,25) table_name,    '                  ||
           '        SUBSTR(a.index_name,1,15) index_name,    '                  ||
           '        SUBSTR(b.column_name,1,25) column_name,  '                  ||
           '        a.uniqueness, '                                             ||
           '        SUBSTR(a.index_type,1,10) index_type     '                  ||
           ' FROM   SYS.dba_indexes     a,   '                                  ||
           '        SYS.dba_ind_columns b    '                                  ||
           ' WHERE  a.owner = '''                                               || v_user1  || '''' ||
           ' AND    a.index_name = b.index_name         '                       ||
           ' AND    a.table_name = b.table_name         '                       ||
           ' AND  ((a.table_name NOT LIKE ''ADB%''  AND '                       ||
           '        a.index_name     LIKE ''SYS%'')     '                       ||
           '      OR '                                                          ||
           '       (a.index_name NOT LIKE ''SYS%''))    '                       ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(a.table_name,1,25) table_name,    '                  ||
           '        SUBSTR(a.index_name,1,15) index_name,    '                  ||
           '        SUBSTR(b.column_name,1,25) column_name,  '                  ||
           '        a.uniqueness, '                                             ||
           '        SUBSTR(a.index_type,1,10) index_type     '                  ||
           ' FROM   SYS.dba_indexes       a, ' 					||
           '        SYS.dba_ind_columns   b  ' 					||
           ' WHERE  a.owner = '''                                               || v_user2  || '''' ||
           ' AND    a.index_name = b.index_name        '                        ||
           ' AND    a.table_name = b.table_name        '                        ||
           ' AND  ((a.table_name NOT LIKE ''ADB%''  AND '                       ||
           '        a.index_name     LIKE ''SYS%'')     '                       ||
           '      OR '                                                          ||
           '       (a.index_name NOT LIKE ''SYS%''))';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,25);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_index_name,15);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,3,v_column_name,25);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,4,v_uniqueness,10);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,5,v_index_type,10);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Index columns in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Index columns in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_index_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,3,v_column_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,4,v_uniqueness);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,5,v_index_type);


      DBMS_OUTPUT.put_line(RPAD(v_table_name,25,' ')  || ' ' ||
                           RPAD(v_index_name,15,' ')  || ' ' ||
                           RPAD(v_column_name,25,' ') || ' ' ||
                           RPAD(v_uniqueness,10,' ')  || ' ' ||
                           RPAD(v_index_type,10,' '));

      v_text := RPAD(v_table_name,25,' ')  || ' ' ||
                RPAD(v_index_name,15,' ')  || ' ' ||
                RPAD(v_column_name,25,' ') || ' ' ||
                RPAD(v_uniqueness,10,' ')  || ' ' ||
                RPAD(v_index_type,10,' ');

      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- DB link index columns not on the local side.
  --

  v_sql := 'SELECT  SUBSTR(a.table_name,1,25) table_name,    '                  ||
           '        SUBSTR(a.index_name,1,15) index_name,    '                  ||
           '        SUBSTR(b.column_name,1,25) column_name,  '                  ||
           '        a.uniqueness, '                                             ||
           '        SUBSTR(a.index_type,1,10) index_type     '                  ||
           ' FROM   SYS.dba_indexes     a,   '                                  ||
           '        SYS.dba_ind_columns b    '                                  ||
           ' WHERE  a.owner = '''                                               || v_user2  || '''' ||
           ' AND    a.index_name = b.index_name         '                       ||
           ' AND    a.table_name = b.table_name         '                       ||
           ' AND  ((a.table_name NOT LIKE ''ADB%''  AND '                       ||
           '        a.index_name     LIKE ''SYS%'')     '                       ||
           '      OR '                                                          ||
           '       (a.index_name NOT LIKE ''SYS%''))    '                       ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(a.table_name,1,25) table_name,    '                  ||
           '        SUBSTR(a.index_name,1,15) index_name,    '                  ||
           '        SUBSTR(b.column_name,1,25) column_name,  '                  ||
           '        a.uniqueness, '                                             ||
           '        SUBSTR(a.index_type,1,10) index_type     '                  ||
           ' FROM   SYS.dba_indexes       a, '                                  ||
           '        SYS.dba_ind_columns   b  '                                  ||
           ' WHERE  a.owner = '''                                               || v_user1  || '''' ||
           ' AND    a.index_name = b.index_name        '                        ||
           ' AND    a.table_name = b.table_name        '                        ||
           ' AND  ((a.table_name NOT LIKE ''ADB%''  AND '                       ||
           '        a.index_name     LIKE ''SYS%'')     '                       ||
           '      OR '                                                          ||
           '       (a.index_name NOT LIKE ''SYS%''))';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,25);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_index_name,15);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,3,v_column_name,25);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,4,v_uniqueness,10);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,5,v_index_type,10);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Index columns in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Index columns in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_index_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,3,v_column_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,4,v_uniqueness);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,5,v_index_type);


      DBMS_OUTPUT.put_line(RPAD(v_table_name,25,' ')  || ' ' ||
                           RPAD(v_index_name,15,' ')  || ' ' ||
                           RPAD(v_column_name,25,' ') || ' ' ||
                           RPAD(v_uniqueness,10,' ')  || ' ' ||
                           RPAD(v_index_type,10,' '));

      v_text := RPAD(v_table_name,25,' ')  || ' ' ||
                RPAD(v_index_name,15,' ')  || ' ' ||
                RPAD(v_column_name,25,' ') || ' ' ||
                RPAD(v_uniqueness,10,' ')  || ' ' ||
                RPAD(v_index_type,10,' ');

      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Sequences on Local side not on the DBlink side.
  --

  v_sql := 'SELECT  sequence_name '                         ||
           ' FROM   SYS.dba_sequences '                     ||
           ' WHERE  sequence_owner = '''                    || v_user1  || '''' ||
           ' MINUS '                                        ||
           ' SELECT sequence_name '                         ||
           ' FROM   SYS.dba_sequences '                     || 
           ' WHERE  sequence_owner = '''                    || v_user2  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_sequence_name,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Sequences in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Sequences in schema : ' || v_user1 || ' not in schema : ' || v_user2 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_sequence_name);

      DBMS_OUTPUT.put_line(v_sequence_name);

      v_text := v_sequence_name;
      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Sequences on DB link side not on the local side.
  --

  v_sql := 'SELECT  sequence_name '                         ||
           ' FROM   SYS.dba_sequences '                     || 
           ' WHERE  sequence_owner = '''                    || v_user2  || '''' ||
           ' MINUS '                                        ||
           ' SELECT sequence_name '                         ||
           ' FROM   SYS.dba_sequences '                     ||
           ' WHERE  sequence_owner = '''                    || v_user1  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_sequence_name,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      ELSE
         v_diffs_found := 'Y';
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         DBMS_OUTPUT.put_line('Sequences in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.');
         DBMS_OUTPUT.put_line('*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         v_text := 'Sequences in schema : ' || v_user2 || ' not in schema : ' || v_user1 || '.';
         UTL_FILE.put_line(v_output_file, v_text);
         UTL_FILE.put_line(v_output_file, '*********************************************************************************************');
         UTL_FILE.putf    (v_output_file,  v_no_rows||CHR(10));
         v_count := 0;
      END IF;

      DBMS_SQL.column_value(v_cursor_id,1,v_sequence_name);

      DBMS_OUTPUT.put_line(v_sequence_name);

      v_text := v_sequence_name;
      UTL_FILE.put_line   (v_output_file, v_text);

  END LOOP;

  DBMS_SQL.close_cursor(v_cursor_id);

  IF  v_diffs_found = 'Y' THEN
      DBMS_OUTPUT.put_line('.');
      DBMS_OUTPUT.put_line('Data Migration Tool has detected structural differences.');
      DBMS_OUTPUT.put_line('.');
      UTL_FILE.putf    (v_output_file, v_no_rows||CHR(10));
      v_text := 'Data Migration Tool has detected structural differences.'; 
      UTL_FILE.put_line(v_output_file, v_text); 
      UTL_FILE.putf    (v_output_file, v_no_rows||CHR(10));
  END IF;

  UTL_FILE.fclose  (v_output_file);

END;  
/

