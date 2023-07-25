set serveroutput on

declare 
cursor segment_cursor is
SELECT TABLE_NAME, tablespace_name, NEXT_EXTENT FROM DBA_TABLES WHERE OWNER='PIAS' and next_extent is not null 
UNION
SELECT INDEX_NAME, tablespace_name, NEXT_EXTENT FROM DBA_INDEXES WHERE OWNER='PIAS' and next_extent is not null 
order by 3 desc;

segments segment_cursor%rowtype;
free_extent number;

begin
 dbms_output.put_line('Segments whose next extent is greater than the largest available free extent');
 dbms_output.put_line('============================================================================');
 for x in segment_cursor
 loop
   begin
     select max(bytes) 
     into free_extent
     from dba_free_space
     where tablespace_name=x.tablespace_name
     and bytes > (x.next_extent);
    exception
     when no_data_found then

   dbms_output.put('WARNING:');
   dbms_output.put(x.table_name);
   dbms_output.put(' requires ');
   dbms_output.put(x.next_extent);
   dbms_output.put(' bytes in tablespace ');
   dbms_output.put_line(x.tablespace_name);
     
     when others then raise;
    end;
    if free_extent is null then
   dbms_output.put('WARNING:');
   dbms_output.put(x.table_name);
   dbms_output.put(' requires ');
   dbms_output.put(x.next_extent);
   dbms_output.put(' bytes in tablespace ');
   dbms_output.put_line(x.tablespace_name);
    
    end if;
 end loop;
 dbms_output.put_line('============================================================================');
end;
/


