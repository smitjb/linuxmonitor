SET serveroutput ON SIZE 1000000

CREATE OR REPLACE PROCEDURE checkschemaDB (p_username_1   IN VARCHAR2,
                                           p_username_2   IN VARCHAR2,
                                           p_db_link      IN VARCHAR2)   AS
  v_cursor_id     NUMBER;
  v_sql           LONG;
  v_num_rows      INTEGER;
  v_count         NUMBER(10) := 1;

  v_user1         dba_tables.owner%TYPE;
  v_user2         dba_tables.owner%TYPE;
  v_dblink        dba_tables.table_name%TYPE;

  v_dummy         NUMBER; 
  v_object_type   dba_objects.object_type%TYPE;
  v_object_name   dba_objects.object_name%TYPE;
  v_synonym_name  dba_synonyms.synonym_name%TYPE;
  v_table_name    dba_tables.table_name%TYPE;

  --  v_column_name      dba_tab_columns.column_name%TYPE;
  --  v_data_type        dba_tab_columns.data_type%TYPE;
  --  v_data_length      dba_tab_columns.data_length%TYPE;
  --  v_data_precision   dba_tab_columns.data_precision%TYPE;
  --  v_data_scale       dba_tab_columns.data_scale%TYPE;
  --  v_nullable         VARCHAR2(8);

  v_column_name      VARCHAR2(30);
  v_data_type        VARCHAR2(10);
  v_data_length      VARCHAR2(6);
  v_data_precision   VARCHAR2(9);
  v_data_scale       VARCHAR2(5);
  v_nullable         VARCHAR2(8);

  v_constraint_name  dba_constraints.constraint_name%TYPE;
  v_constraint_type  dba_constraints.constraint_type%TYPE;
  v_status           dba_constraints.status%TYPE;
  v_deferrable       dba_constraints.deferrable%TYPE;
  v_deferred         dba_constraints.deferred%TYPE;

  v_index_name       dba_indexes.index_name%TYPE;
  v_uniqueness       dba_indexes.uniqueness%TYPE;
  v_index_type       dba_indexes.index_type%TYPE;

  v_sequence_name    dba_sequences.sequence_name%TYPE;

BEGIN

  v_user1  := p_username_1;
  v_user2  := p_username_2;
  v_dblink := p_db_link;


  --
  -- Objects on Local side not on the DBlink side.
  --

  v_sql := 'SELECT  SUBSTR(object_name,1,25) object_name, ' ||
           '        object_type              object_type '  ||
           ' FROM   dba_objects'                            || 
           ' WHERE  owner = '''                             || p_username_1  || '''' ||
           ' MINUS '                                        ||
           ' SELECT SUBSTR(object_name,1,25) object_name, ' ||
           '        object_type              object_type '  ||
           ' FROM   dba_objects@'                           || p_db_link     ||
           ' WHERE  owner = '''                             || p_username_2  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_object_name,50);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_object_type,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Local objects not DB Link side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_object_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_object_type);

      DBMS_OUTPUT.put_line(v_object_type || ' ' || v_object_name);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Objects on DBlink side not on Local side.
  --
  
  v_sql := 'SELECT  SUBSTR(object_name,1,25) object_name, ' || 
           '        object_type              object_type '  ||
           ' FROM   dba_objects@'                           || p_db_link     ||
           ' WHERE  owner = '''                             || p_username_2  || '''' || 
           ' MINUS '                                        ||
           ' SELECT SUBSTR(object_name,1,25) object_name, ' ||
           '        object_type              object_type '  ||
           ' FROM   dba_objects  '                          ||
           ' WHERE  owner = '''                             || p_username_1  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_object_name,50);
  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,2,v_object_type,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);
  
  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      END IF;
     
      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Remote objects not on Local DB side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_object_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_object_type);

      DBMS_OUTPUT.put_line(v_object_type || ' ' || v_object_name);

  END LOOP;  

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Synonyms on Local side not on the DBlink side.
  --

  v_sql := 'SELECT  synonym_name '                          ||
           ' FROM   dba_synonyms '                          ||
           ' WHERE  owner = '''                             || p_username_1  || '''' ||
           ' MINUS '                                        ||
           ' SELECT synonym_name '                          ||
           ' FROM   dba_synonyms@'                          || p_db_link     ||
           ' WHERE  owner = '''                             || p_username_2  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_synonym_name,40);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Local synonyms not DB Link side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_synonym_name);

      DBMS_OUTPUT.put_line(v_synonym_name);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);



  --
  -- Synonyms on DBlink side not on the Local side.
  --

  v_sql := 'SELECT  synonym_name '                          ||
           ' FROM   dba_synonyms@'                          || p_db_link     ||
           ' WHERE  owner = '''                             || p_username_2  || '''' ||
           ' MINUS '                                        ||
           ' SELECT synonym_name '                          ||
           ' FROM   dba_synonyms '                          ||
           ' WHERE  owner = '''                             || p_username_1  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_synonym_name,40);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('DB Link synonyms not on local side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_synonym_name);

      DBMS_OUTPUT.put_line(v_synonym_name);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Tables on Local side not on the DBlink side.
  --

  v_sql := 'SELECT  table_name '                            ||
           ' FROM   dba_tables '                            ||
           ' WHERE  owner = '''                             || p_username_1  || '''' ||
           ' MINUS '                                        ||
           ' SELECT table_name '                            ||
           ' FROM   dba_tables@'                            || p_db_link     ||
           ' WHERE  owner = '''                             || p_username_2  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Local tables not DB Link side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);

      DBMS_OUTPUT.put_line(v_table_name);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);

  --
  -- Tables on DBlink side not on the local side.
  --

  v_sql := 'SELECT  table_name '                            ||
           ' FROM   dba_tables@'                            || p_db_link     ||
           ' WHERE  owner = '''                             || p_username_2  || '''' ||
           ' MINUS '                                        ||
           ' SELECT table_name '                            ||
           ' FROM   dba_tables '                            || 
           ' WHERE  owner = '''                             || p_username_1  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_table_name,30);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('DBlink tables not the local side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);

      DBMS_OUTPUT.put_line(v_table_name);

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
           ' FROM   dba_tab_columns '                       			||
           ' WHERE  owner = '''                             			|| p_username_1  || '''' ||
           ' MINUS '                                        			||
           ' SELECT SUBSTR(table_name,1,30)    table_name, '      		||
           '        SUBSTR(column_name,1,30)   column_name, '                   ||
           '        SUBSTR(data_type,1,10)     data_type, '                     ||
           '        SUBSTR(data_length,1,6)    length,    '                     ||
           '        SUBSTR(data_precision,1,9) precision, '                     ||
           '        SUBSTR(data_scale,1,5)     scale,     '                     ||
           ' SUBSTR(DECODE(nullable,''Y'',''NULL'',''N'',''NOT NULL''),1,8) nullable '  ||
           ' FROM   dba_tab_columns@'                          			|| p_db_link     ||
           ' WHERE  owner = '''                             			|| p_username_2  || '''';

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
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Local table columns not DB Link side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_column_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,3,v_data_type);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,4,v_data_length);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,5,v_data_precision);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,6,v_data_scale);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,7,v_nullable);

      DBMS_OUTPUT.put_line(RPAD(v_table_name,30,' ')     || ' ' || 
                           RPAD(v_column_name,30,' ')    || ' ' ||
                           RPAD(v_nullable,9,' ')        || ' ' ||
                           RPAD(v_data_type,12,' ')      || ' ' ||
                           RPAD(v_data_length,7,' ')     || ' ' ||
                           RPAD(v_data_precision,12,' ') || ' ' ||
                           RPAD(v_data_scale,6,' '));

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
           ' FROM   dba_tab_columns@'                                           || p_db_link     ||
           ' WHERE  owner = '''                                                 || p_username_2  || '''' ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(table_name,1,30)    table_name, '                    ||
           '        SUBSTR(column_name,1,30)   column_name, '                   ||
           '        SUBSTR(data_type,1,10)     data_type, '                     ||
           '        SUBSTR(data_length,1,6)    length,    '                     ||
           '        SUBSTR(data_precision,1,9) precision, '                     ||
           '        SUBSTR(data_scale,1,5)     scale,     '                     ||
           ' SUBSTR(DECODE(nullable,''Y'',''NULL'',''N'',''NOT NULL''),1,8) nullable '  ||
           ' FROM   dba_tab_columns '                                           || 
           ' WHERE  owner = '''                                                 || p_username_1  || '''';

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
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('DB link table columns not on local side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_table_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,2,v_column_name);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,3,v_data_type);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,4,v_data_length);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,5,v_data_precision);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,6,v_data_scale);
      DBMS_SQL.COLUMN_VALUE(v_cursor_id,7,v_nullable);

      DBMS_OUTPUT.put_line(RPAD(v_table_name,30,' ')     || ' ' ||
                           RPAD(v_column_name,30,' ')    || ' ' ||
                           RPAD(v_nullable,9,' ')        || ' ' ||
                           RPAD(v_data_type,12,' ')      || ' ' ||
                           RPAD(v_data_length,7,' ')     || ' ' ||
                           RPAD(v_data_precision,12,' ') || ' ' ||
                           RPAD(v_data_scale,6,' '));

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
           ' FROM   dba_constraints   a, '                                      ||
           '        dba_cons_columns  b  '                                      ||
           ' WHERE  a.constraint_type  in (''P'',''R'',''U'')  '                ||
           ' AND    a.owner = '''                                               || p_username_1  || '''' ||
           ' AND    b.owner = '''                                               || p_username_1  || '''' ||
           ' AND    a.table_name      = b.table_name      '                     ||
           ' AND    a.constraint_name = b.constraint_name '                     ||
           ' AND    a.constraint_name NOT LIKE ''SYS%''   '                     ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(a.table_name,1,25) table_name,           '           ||
           '        SUBSTR(a.constraint_name,1,20) constraint_name, '           ||
           '        SUBSTR(a.constraint_type,1,10) constraint_type, '           ||
           '        SUBSTR(b.column_name,1,25) column_name,         '           ||
           '        a.status,     '                                             ||
           '        a.deferrable, '                                             ||
           '        SUBSTR(a.deferred,1,20) deferred  '                         ||
           ' FROM   dba_constraints@'                                           || p_db_link     || ' a, ' ||
           '        dba_cons_columns@'                                          || p_db_link     || ' b  ' ||
           ' WHERE  a.constraint_type  in (''P'',''R'',''U'')  '                ||
           ' AND    a.owner = '''                                               || p_username_2  || '''' ||
           ' AND    b.owner = '''                                               || p_username_2  || '''' ||
           ' AND    a.table_name      = b.table_name      '                     ||
           ' AND    a.constraint_name = b.constraint_name '                     ||
           ' AND    a.constraint_name NOT LIKE ''SYS%''';

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
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Local constraint columns not on the DBlink side.');
         DBMS_OUTPUT.put_line('.');
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
           ' FROM   dba_constraints@'                                           || p_db_link     || ' a, ' ||
           '        dba_cons_columns@'                                          || p_db_link     || ' b  ' ||
           ' WHERE  a.constraint_type  in (''P'',''R'',''U'')  '                ||
           ' AND    a.owner = '''                                               || p_username_2  || '''' ||
           ' AND    b.owner = '''                                               || p_username_2  || '''' ||
           ' AND    a.table_name      = b.table_name      '                     ||
           ' AND    a.constraint_name = b.constraint_name '                     ||
           ' AND    a.constraint_name NOT LIKE ''SYS%''   '                     ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(a.table_name,1,25) table_name,           '           ||
           '        SUBSTR(a.constraint_name,1,20) constraint_name, '           ||
           '        SUBSTR(a.constraint_type,1,10) constraint_type, '           ||
           '        SUBSTR(b.column_name,1,25) column_name,         '           ||
           '        a.status,     '                                             ||
           '        a.deferrable, '                                             ||
           '        SUBSTR(a.deferred,1,20) deferred  '                         ||
           ' FROM   dba_constraints  a, '                                       || 
           '        dba_cons_columns b  '                                       || 
           ' WHERE  a.constraint_type  in (''P'',''R'',''U'')  '                ||
           ' AND    a.owner = '''                                               || p_username_1  || '''' ||
           ' AND    b.owner = '''                                               || p_username_1  || '''' ||
           ' AND    a.table_name      = b.table_name      '                     ||
           ' AND    a.constraint_name = b.constraint_name '                     ||
           ' AND    a.constraint_name NOT LIKE ''SYS%''';

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
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('DB link constraint columns not on the local side.');
         DBMS_OUTPUT.put_line('.');
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
           ' FROM   dba_indexes     a,   '                                      ||
           '        dba_ind_columns b    '                                      ||
           ' WHERE  a.owner = '''                                               || p_username_1  || '''' ||
           ' AND    a.index_name = b.index_name    '                            ||
           ' AND    a.table_name = b.table_name    '                            ||
           ' AND    a.index_name NOT LIKE ''SYS%'' '                            ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(a.table_name,1,25) table_name,    '                  ||
           '        SUBSTR(a.index_name,1,15) index_name,    '                  ||
           '        SUBSTR(b.column_name,1,25) column_name,  '                  ||
           '        a.uniqueness, '                                             ||
           '        SUBSTR(a.index_type,1,10) index_type     '                  ||
           ' FROM   dba_indexes@'                                               || p_db_link     || ' a, ' ||
           '        dba_ind_columns@'                                           || p_db_link     || ' b  ' ||
           ' WHERE  a.owner = '''                                               || p_username_2  || '''' ||
           ' AND    a.index_name = b.index_name    '                            ||
           ' AND    a.table_name = b.table_name    '                            ||
           ' AND    a.index_name NOT LIKE ''SYS%''';

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
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Local constraint columns not on the DBlink side.');
         DBMS_OUTPUT.put_line('.');
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
           ' FROM   dba_indexes@'                                               || p_db_link     || ' a, ' ||
           '        dba_ind_columns@'                                           || p_db_link     || ' b  ' ||
           ' WHERE  a.owner = '''                                               || p_username_2  || '''' ||
           ' AND    a.index_name = b.index_name    '                            ||
           ' AND    a.table_name = b.table_name    '                            ||
           ' AND    a.index_name NOT LIKE ''SYS%'' '                            ||
           ' MINUS '                                                            ||
           ' SELECT SUBSTR(a.table_name,1,25) table_name,    '                  ||
           '        SUBSTR(a.index_name,1,15) index_name,    '                  ||
           '        SUBSTR(b.column_name,1,25) column_name,  '                  ||
           '        a.uniqueness, '                                             ||
           '        SUBSTR(a.index_type,1,10) index_type     '                  ||
           ' FROM   dba_indexes     a, '                                        ||
           '        dba_ind_columns b  '                                        ||
           ' WHERE  a.owner = '''                                               || p_username_1  || '''' ||
           ' AND    a.index_name = b.index_name    '                            ||
           ' AND    a.table_name = b.table_name    '                            ||
           ' AND    a.index_name NOT LIKE ''SYS%''';

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
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('DB link index columns not on the local side.');
         DBMS_OUTPUT.put_line('.');
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

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);



  --
  -- Sequences on Local side not on the DBlink side.
  --

  v_sql := 'SELECT  sequence_name '                         ||
           ' FROM   dba_sequences '                         ||
           ' WHERE  sequence_owner = '''                    || p_username_1  || '''' ||
           ' MINUS '                                        ||
           ' SELECT sequence_name '                         ||
           ' FROM   dba_sequences@'                         || p_db_link     ||
           ' WHERE  sequence_owner = '''                    || p_username_2  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_sequence_name,20);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Local Sequences not DB Link side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_sequence_name);

      DBMS_OUTPUT.put_line(v_sequence_name);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);


  --
  -- Sequences on DB link side not on the local side.
  --

  v_sql := 'SELECT  sequence_name '                         ||
           ' FROM   dba_sequences@'                         || p_db_link     ||
           ' WHERE  sequence_owner = '''                    || p_username_2  || '''' ||
           ' MINUS '                                        ||
           ' SELECT sequence_name '                         ||
           ' FROM   dba_sequences '                         ||
           ' WHERE  sequence_owner = '''                    || p_username_1  || '''';

  v_cursor_id := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQl.V7);

  DBMS_SQL.DEFINE_COLUMN(v_cursor_id,1,v_sequence_name,20);

  v_num_rows := DBMS_SQL.EXECUTE(v_cursor_id);

  v_count := 1;
  LOOP

      IF DBMS_SQL.FETCH_ROWS(v_cursor_id) = 0 THEN
         EXIT;
      END IF;

      IF v_count = 1 THEN
         DBMS_OUTPUT.put_line('.');
         DBMS_OUTPUT.put_line('Sequences on DB link side not on the local side.');
         DBMS_OUTPUT.put_line('.');
         v_count := 0;
      END IF;

      DBMS_SQL.COLUMN_VALUE(v_cursor_id,1,v_sequence_name);

      DBMS_OUTPUT.put_line(v_sequence_name);

  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);



END;  
/

