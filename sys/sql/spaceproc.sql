SET serveroutput on SIZE 1000000

DECLARE


  v_tablespace_name     VARCHAR2(120); 

  v_tot_bytes           VARCHAR2(20);
  v_tot_phys_bytes      VARCHAR2(25);
  v_tot_alloc_bytes     VARCHAR2(24);

  v_comma               VARCHAR2(1);
  v_comma_2             VARCHAR2(1);

  v_maxbytes_free       VARCHAR2(20);
  v_sumbytes_free       VARCHAR2(20);
  v_free_bytes          VARCHAR2(20);

  v_used                VARCHAR2(20);
  v_used_bytes          VARCHAR2(20);
  v_tot_used_bytes      VARCHAR2(24);

  v_largest_ext         VARCHAR2(20);
  v_largest_ext_bytes   VARCHAR2(24);

  v_table               VARCHAR2(20);
  v_table_bytes         VARCHAR2(24);

  v_index               VARCHAR2(20);
  v_index_bytes         VARCHAR2(24);

  CURSOR  c_tablespace IS
    SELECT DISTINCT(tablespace_name) tspname, 
           SUM(bytes)                tspbytes
    from   dba_data_files
    group by tablespace_name;

  CURSOR  c_max_bytes_free (c_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
    SELECT SUM(bytes)  sumbytes,
           MAX(bytes)  maxbytes
    FROM   dba_free_Space
    WHERE  tablespace_name = c_tablespace_name;

  CURSOR  c_used      (c_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
    SELECT SUM(bytes)  bytesused
    FROM   dba_extents
    WHERE  tablespace_name = c_tablespace_name;

  CURSOR  c_table     (c_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
    SELECT MAX(next_extent)
    FROM   dba_tables
    WHERE  tablespace_name = c_tablespace_name;

  CURSOR  c_index     (c_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
    SELECT MAX(next_extent)
    FROM   dba_indexes
    WHERE  tablespace_name = c_tablespace_name;      
      
BEGIN
    

  DBMS_OUTPUT.put_line('.');
  DBMS_OUTPUT.put_line('Tablespace                  Physical Size      Bytes Free      Bytes Used     Largest Ext   TABLE NextExt   INDEX NextExt'); 
  DBMS_OUTPUT.put_line('.');
  
  FOR c_tablespace_rec IN c_tablespace
  LOOP

    -- Total physical space used

    v_tablespace_name  := c_tablespace_rec.tspname;

    v_tot_bytes       := LPAD(c_tablespace_rec.tspbytes,20,' ');


    IF instr(substr(v_tot_bytes,11,1),' ') > 0 THEN
       v_comma := ' ';
    ELSE
       v_comma := ',';
    END IF;

    v_tot_phys_bytes    := substr(v_tot_bytes,1,11) || v_comma ||
                           substr(v_tot_bytes,12,3) || ','     ||
                           substr(v_tot_bytes,15,3) || ','     ||
                           substr(v_tot_bytes,18,3);

    -- Total Free Space

    OPEN  c_max_bytes_free (v_tablespace_name);
    FETCH c_max_bytes_free INTO v_sumbytes_free,
                                v_maxbytes_free;
    IF c_max_bytes_free%NOTFOUND THEN
       CLOSE c_max_bytes_free;
    ELSE
       CLOSE c_max_bytes_free;
    END IF;

    v_free_bytes    := LPAD(v_sumbytes_free,20,' ');

    IF instr(substr(v_free_bytes,11,1),' ') > 0 THEN
       v_comma := ' ';
    ELSE
       v_comma := ',';
    END IF;    

    v_tot_alloc_bytes   := substr(v_free_bytes,1,11) || v_comma ||
                           substr(v_free_bytes,12,3) || ','     ||
                           substr(v_free_bytes,15,3) || ','     ||
                           substr(v_free_bytes,18,3);


    -- Largest Extent Free

    v_largest_ext   := LPAD(v_maxbytes_free,20,' ');
    
    IF instr(substr(v_largest_ext,11,1),' ') > 0 THEN
       v_comma := ' ';
    ELSE
       v_comma := ',';
    END IF;

    v_largest_ext_bytes := substr(v_largest_ext,1,11) || v_comma ||
                           substr(v_largest_ext,12,3) || ','     ||
                           substr(v_largest_ext,15,3) || ','     ||
                           substr(v_largest_ext,18,3);

    -- Total Used Space

    OPEN  c_used (v_tablespace_name);
    FETCH c_used INTO v_used;
                     
    IF c_used%NOTFOUND THEN
       CLOSE c_used;
    ELSE
       CLOSE c_used;
    END IF;

    v_used_bytes    := LPAD(v_used,20,' ');

    IF instr(substr(v_used_bytes,11,1),' ') > 0 THEN
       v_comma := ' ';
    ELSE
       v_comma := ',';
    END IF;

    v_tot_used_bytes    := substr(v_used_bytes,1,11) || v_comma ||
                           substr(v_used_bytes,12,3) || ','     ||
                           substr(v_used_bytes,15,3) || ','     ||
                           substr(v_used_bytes,18,3);


    -- Largest NEXT EXTENT expected   TABLES

    OPEN  c_table (v_tablespace_name);
    FETCH c_table INTO v_table;

    IF c_table%NOTFOUND THEN
       CLOSE c_table;
    ELSE
       CLOSE c_table;
    END IF;

    v_table    := LPAD(v_table,20,' ');

    IF instr(substr(v_table,11,1),' ') > 0 THEN
       v_comma := ' ';
    ELSE
       v_comma := ',';
    END IF;

    IF instr(substr(v_table,14,1),' ') > 0 THEN
       v_comma_2 := ' ';
    ELSE
       v_comma_2 := ',';
    END IF;

    v_table_bytes       := substr(v_table,1,11) || v_comma   ||
                           substr(v_table,12,3) || v_comma_2 ||
                           substr(v_table,15,3) || ','       ||
                           substr(v_table,18,3);


    -- Largest NEXT EXTENT expected   INDEXES

    OPEN  c_index (v_tablespace_name);
    FETCH c_index INTO v_index;

    IF c_index%NOTFOUND THEN
       CLOSE c_index;
    ELSE
       CLOSE c_index;
    END IF;

    v_index    := LPAD(v_index,20,' ');

    IF instr(substr(v_index,11,1),' ') > 0 THEN
       v_comma := ' ';
    ELSE
       v_comma := ',';
    END IF;

    IF instr(substr(v_index,14,1),' ') > 0 THEN
       v_comma_2 := ' ';
    ELSE
       v_comma_2 := ',';
    END IF;

    v_index_bytes       := substr(v_index,1,11) || v_comma   ||
                           substr(v_index,12,3) || v_comma_2 ||
                           substr(v_index,15,3) || ','       ||
                           substr(v_index,18,3);

    v_tablespace_name    := substr(RPAD(v_tablespace_name,25,' '),1,25);
    v_tot_phys_bytes     := RPAD(v_tot_phys_bytes,24,' ');
    v_tot_alloc_bytes    := RPAD(v_tot_alloc_bytes,24,' ');
    v_tot_used_bytes     := RPAD(v_tot_used_bytes,24,' ');
    v_largest_ext_bytes  := RPAD(v_largest_ext_bytes,24,' ');

    v_table_bytes        := RPAD(v_table_bytes,24,' ');
    v_index_bytes        := RPAD(v_index_bytes,24,' ');

    DBMS_OUTPUT.put_line( SUBSTR(v_tablespace_name,1,25)    ||
                          SUBSTR(v_tot_phys_bytes,8,16)     ||
                          SUBSTR(v_tot_alloc_bytes,8,16)    ||
                          SUBSTR(v_tot_used_bytes,8,16)     ||
                          SUBSTR(v_largest_ext_bytes,8,16)  ||
                          SUBSTR(v_table_bytes,8,16)        ||
                          SUBSTR(v_index_bytes,8,16)
                        );

  END LOOP;

END;
/

