set serveroutput on FORMAT WRAPPED
declare 
 pk_owner varchar2(20):=upper(nvl('&1',user));
 pk_table varchar2(20):=upper('&2');
 fk_cols varchar2(1000);
 pk_cols varchar2(1000);
begin
 dbms_output.enable(1000000);
 dbms_output.put_line('--');
 dbms_output.put_line('--Foreign keys for  '||pk_owner||'.'||pk_table);
 dbms_output.put_line('--');
   
   
 for fks in (select fk.owner fk_owner, fk.table_name fk_table_name,fk.constraint_name fk_constraint_name, decode(fk.status,'ENABLED','enable','DISABLED','disable') fk_status,
                    pk.owner pk_owner, pk.table_name pk_table_name,pk.constraint_name pk_constraint_name
                    from dba_constraints fk INNER JOIN 
                    dba_constraints pk
                    ON fk.r_owner=pk.owner
                    and fk.r_constraint_name=pk.constraint_name
                    WHERE pk.owner=pk_owner AND pk.TABLE_NAME=pk_table
                    order by pk_table,pk_constraint_name,fk_owner,fk_table_name

)
loop
 dbms_output.put_line('alter table '||fks.fk_owner||'.'||fks.fk_table_NAME);
 dbms_output.put_line('add constraint '||fks.fk_constraint_name ||' foreign key');
 fk_cols:='(';
 pk_cols:='(';
 for cols in (select fkc.table_name fck_table_name,fkc.column_name fkc_column_name,fkc.position fkc_position,
 pkc.table_name pck_table_name,pkc.column_name pkc_column_name,pkc.position pkc_position
 from
dba_cons_columns fkc
inner join dba_cons_columns pkc
on fkc.position = pkc.position
where fkc.constraint_name=fks.fk_constraint_name
and pkc.constraint_name=fks.pk_constraint_name
order by fkc.position)
 loop
  fk_cols:=fk_cols||cols.fkc_column_name||',';
  pk_cols:=pk_cols||cols.pkc_column_name||',';
 end loop;
 fk_cols:=rtrim(fk_cols,',')||')';
 pk_cols:=rtrim(pk_cols,',')||')';
 dbms_output.put_line(fk_cols||' references '||fks.pk_table_name||' ' ||pk_cols||' '||fks.fk_status||';');
 dbms_output.NEW_LINE;
 
end loop;
 dbms_output.put_line('--');
 dbms_output.put_line('-- End of foreign keys for  '||pk_owner||'.'||pk_table);
 dbms_output.put_line('--');
end;
/