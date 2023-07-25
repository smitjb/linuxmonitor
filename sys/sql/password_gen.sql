
declare

 start_chars varchar2(26):='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
 all_chars varchar2(36):='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
 passwd varchar2(30);
 
  all_chars_length constant number:=36;
  start_chars_length constant number:=26;
  
  begin
dbms_output.enable;

 passwd:=substr(start_chars,dbms_random.value(1,26),1);
 for i in 2..8 loop
  passwd:=passwd|| substr(all_chars,dbms_random.value(1,36),1);
 
 end loop;
 dbms_output.put_line(passwd);
 end;
 /
 
