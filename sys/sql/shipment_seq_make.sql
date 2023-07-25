-- #############################################################################
-- # Name   : shipment_seq_make.sql
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
set verify off
set feedback off
set pagesize 0
prompt "##############################################################"
prompt "         CSSMT_SEQ sequence calcularion script"
prompt "##############################################################"
prompt

accept v_new_cssmt_seq prompt 'Enter NEW CSSMT_SEQ value, e.g. FK001 > '

declare

  v_first_letter   varchar2(1);
  v_second_letter  varchar2(1);
  v_remainder      number;
  v_trans_value    number;
  v_modulus_value  number;

  cursor c1 is select min_value
                     ,max_value
                     ,cache_size
                     ,increment_by
                     ,decode(cycle_flag,'Y','cycle','nocycle') cycle_flag
                     ,decode(order_flag,'Y','order','noorder') order_flag
               from user_sequences
               where sequence_name = 'CSSMT_SEQ';

  function f_translate_letter(v_input_letter varchar2)
  return number
  is
    v_value number;
  begin

    select decode(v_input_letter,'A','0'
                                ,'B','1'
                                ,'C','2'
                                ,'D','3'
                                ,'E','4'
                                ,'F','5'
                                ,'G','6'
                                ,'H','7'
                                ,'I','8'
                                ,'J','9'
                                ,'K','10'
                                ,'L','11'
                                ,'M','12'
                                ,'N','13'
                                ,'O','14'
                                ,'P','15'
                                ,'Q','16'
                                ,'R','17'
                                ,'S','18'
                                ,'T','19'
                                ,'U','20'
                                ,'V','21'
                                ,'W','22'
                                ,'X','23'
                                ,'Y','24'
                                ,'Z','25')
    into v_value
    from dual;

    return v_value;
  end f_translate_letter;

begin

  select upper(substr('&v_new_cssmt_seq',1,1))
  into v_first_letter
  from dual;

  select upper(substr('&v_new_cssmt_seq',2,1))
  into v_second_letter
  from dual;

  select substr('&v_new_cssmt_seq',3)
  into v_remainder
  from dual;

  v_trans_value   := f_translate_letter(v_first_letter);
  v_trans_value   := (v_trans_value * 1000) * 26;

  v_modulus_value := f_translate_letter(v_second_letter);
  v_modulus_value := v_modulus_value * 1000;

  v_trans_value := v_trans_value + v_modulus_value||v_remainder;

  for v1 in c1
  loop

    dbms_output.put_line(chr(10)||'##### Create statement for the REQUESTED sequence values #####'||chr(10));
    dbms_output.put_line('create sequence CSSMT_SEQ');
    dbms_output.put_line('start with '||v_trans_value);
    dbms_output.put_line('minvalue '||v1.min_value);
    dbms_output.put_line('maxvalue '||v1.max_value);
    dbms_output.put_line('cache '||v1.cache_size);
    dbms_output.put_line('increment by '||v1.increment_by);
    dbms_output.put_line(v1.cycle_flag);
    dbms_output.put_line(v1.order_flag);

  end loop;
end;
/

select chr(10)||'##### Recreate statement for the CURRENT sequence #####'||chr(10)||chr(10)||
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

set verify on
set feedback on
set pagesize 14


