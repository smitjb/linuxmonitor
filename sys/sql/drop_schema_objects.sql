
declare 

 type typetab is table of varchar2(40);
 obj_owner varchar2(30):='&1';
 obj_type VARCHAR2(30);
 stmt varchar2(200);
 tt typetab ;
 cursor object_cur is
    select object_name
    from dba_objects
    where owner=obj_owner
    and object_type=obj_type;
    
 BEGIN
     tt:=new typetab(8);
     tt.extend;
     tt(1):='PROCEDURE';
     tt.extend;
     tt(2):='FUNCTION';
     tt.extend;
     tt(3):='PACKAGE';
     tt.extend;
     tt(4):='MATERIALIZED VIEW';
     tt.extend;
     tt(5):='VIEW';
     tt.extend;
     tt(6):='TYPE';
     tt.extend;
     tt(7):='TABLE';
     tt.extend;
     tt(8):='SEQUENCE';
     tt.extend;
     tt(9):='SYNONYM';
    FOR X IN tt.FIRST..tt.LAST
    LOOP
    
      DBMS_OUTPUT.PUT_LINE(tt(X));
      obj_type:=tt(x);
      for obj in object_cur
      loop
        dbms_output.put_line('   '||obj.object_name);
        stmt:='drop '||tt(x)||' '||obj_owner||'."'||obj.object_name||'"';
        dbms_output.put_line(stmt);
        begin
          execute immediate stmt;
           dbms_output.put_line('Dropped '||obj.object_name);
        
        exception 
          when others then 
           dbms_output.put_line('Error '||sqlerrm|| ' dropping '||obj.object_name);
        end;
      end loop;
      
    END LOOP;
 END;

/