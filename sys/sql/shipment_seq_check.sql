-- #############################################################################
-- # Name   : shipment_seq_check.sql
-- # Author : Andrew Morris
-- # Date   : February 2004
-- # Purpose:
-- # Calling routine:
-- # Called routine:
-- # Parameter files:
-- # Notes  : Translates the CSSMT_SEQ sequence into a number
-- # Usage  : Connect as csownerbs1 schema
-- # Modified:
-- # By          When     Change
-- # ----------- -------- ------------------------------------------------------
-- #############################################################################
set serveroutput on size 1000000
set verify off feedback off

declare
  cursor c1 is select last_number
                     ,floor((last_number/1000)/26)  num
                     ,decode(floor(mod((last_number/1000),26)),0,'A'
                                                              ,1,'B'
                                                              ,2,'C'
                                                              ,3,'D'
                                                              ,4,'E'
                                                              ,5,'F'
                                                              ,6,'G'
                                                              ,7,'H'
                                                              ,8,'I'
                                                              ,9,'J'
                                                              ,10,'K'
                                                              ,11,'L'
                                                              ,12,'M'
                                                              ,13,'N'
                                                              ,14,'O'
                                                              ,15,'P'
                                                              ,16,'Q'
                                                              ,17,'R'
                                                              ,18,'S'
                                                              ,19,'T'
                                                              ,20,'U'
                                                              ,21,'V'
                                                              ,22,'W'
                                                              ,23,'X'
                                                              ,24,'Y'
                                                              ,25,'Z') modulus
                     ,lpad(substr(last_number,(length(last_number)-2)),3,0) remainder
               from user_sequences
               where sequence_name='CSSMT_SEQ';

  v_num_chk number;
  v_new_seq varchar2(8);

begin

  for v1 in c1
  loop

    v_num_chk := v1.num;
    while v_num_chk > 26
    loop
      if v1.num >= 26
      then
        v_num_chk := floor(v_num_chk / 26);
      elsif v1.num < 26 
      then
        v_num_chk := v1.num;
      end if;
    end loop;

    select decode(v_num_chk,0,'A'
                            ,1,'B'
                            ,2,'C'
                            ,3,'D'
                            ,4,'E'
                            ,5,'F'
                            ,6,'G'
                            ,7,'H'
                            ,8,'I'
                            ,9,'J'
                            ,10,'K'
                            ,11,'L'
                            ,12,'M'
                            ,13,'N'
                            ,14,'O'
                            ,15,'P'
                            ,16,'Q'
                            ,17,'R'
                            ,18,'S'
                            ,19,'T'
                            ,20,'U'
                            ,21,'V'
                            ,22,'W'
                            ,23,'X'
                            ,24,'Y'
                            ,25,'Z')||v1.modulus||v1.remainder
    into v_new_seq
    from dual;

    dbms_output.put_line(chr(10)||'####### '||v1.last_number||' '||v_new_seq||' #######');
  end loop;

end;
/
set pagesize 0

select 'Recreate statement for the CURRENT sequence'||chr(10)||
'create sequence '||sequence_name||chr(10)||
'start with '||last_number||chr(10)||
'minvalue '||min_value||chr(10)||
'maxvalue '||max_value||chr(10)||
'cache '||cache_size||chr(10)||
'increment by '||increment_by||chr(10)||
decode(cycle_flag,'Y','cycle','nocycle')||chr(10)||
decode(order_flag,'Y','order','noorder')||';'
from user_sequences
where sequence_name = 'CSSMT_SEQ';

select distinct substr(SHIPMENT_REFERENCE,1,2) from CSSMT_SHIPMENTS;

set pagesize 14
set verify on feedback on


