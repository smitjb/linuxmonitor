-- #############################################################################
-- # Name   : gen_create_synonyms.sql
-- # Author : Andrew Morris
-- # Date   : August 2003
-- # Purpose:
-- # Calling routine:
-- # Called routine:
-- # Parameter files:
-- # Notes  : Connect as owning schemas
-- # Usage  : 
-- # Modified:
-- # By          When     Change
-- # ----------- -------- ------------------------------------------------------
-- # AR Morris   03/12/03 Added the RDREADSNAP user
-- # AR Morris   22/01/03 Ensure that synonyms are created with the right length
-- # J Kaminski  16/06/04 Added the NGREPORT user 
-- # J Kaminski  17/06/04 Add csownerup1 synonyms
-- # Des Fox     03/03/05 Add ownerTB and cruiseTB synonyms for TIBCO ADB security CR
-- # Des Fox     16/03/05 Additionad tables for deal schemas for TIBCO-ADB security fix.
-- #                      tables - dehlm_headline_message,dehlm_headline_message_p,
-- #                      detre_tracking_events,detre_tracking_events_p
-- #############################################################################
set serveroutput on size 1000000
set linesize 120

declare

  v_table_owner         varchar2(11) := 'RD'||substr(user,3,length(user)-5)||'VN1';
  v_ref_owner           varchar2(11) := 'RD'||substr(user,3,length(user)-5)||'BS1';
  v_current_user        varchar2(5)  := substr(user,1,2)||substr(user,length(user)-2);
  v_current_user_suffix varchar2(2)  := substr(user,length(user)-2,2);
  v_current_user_prefix varchar2(2)  := substr(user,1,2);
  v_user_type           varchar2(6)  := substr(user,3,length(user)-5);
  v_target_user         varchar2(11);
  v_sql                 varchar2(100);
  v_tab_chk             varchar2(100);

  -- Identify synonyms to drop
  cursor c1 is select synonym_name
               from user_synonyms
               minus
               (select a.synonym_name
               from   user_synonyms a
                     ,all_tab_privs b
               where a.table_owner                     = b.grantor
               and   b.grantee                         = user
               and   a.synonym_name                    = b.table_name
               and  (   substr(user,3,length(user)-5)  = v_user_type
                     or substr(user,3)                 = decode(substr(user,3),'OWNER',v_user_type)
                     or substr(user,3)                 = decode(substr(user,3),'CRUISE','CRUISE',v_user_type)
                     or substr(user,3)                in ('CRUISE'))
               union
               select b.grantor||'_'||a.synonym_name
               from   user_synonyms a
                     ,all_tab_privs b
               where a.table_owner                     = b.grantor
               and   b.grantee                         = user
               and   a.synonym_name                    = b.table_name
               and  (   substr(user,3,length(user)-5)  = v_user_type
                     or substr(user,3)                 = decode(substr(user,3),'OWNER',v_user_type)
                     or substr(user,3)                 = decode(substr(user,3),'CRUISE','CRUISE',v_user_type)
                     or substr(user,3)                in ('CRUISE')));
               
  -- Identify objects to create synonyms on
  cursor c2 is select distinct table_name
                              ,grantor
               from all_tab_privs
               where (grantor          =        v_table_owner
                      or    grantor        like 'CG%BS%')
               and   user       not like 'RD%BS1'
               and   grantor    !=        USER
               and   table_name not in  ('DEPLOYMENT_LABEL')
               and   table_name not in  (select synonym_name
                                         from user_synonyms);
               
  -- Identify objects to create NGSUPPORT synonyms on
  cursor c3 is select distinct table_name
                              ,owner
               from all_tables
               where (   substr(owner,3,length(owner)-5) = 'OWNER' 
                      or substr(owner,3,length(owner)-5) = 'CRUISE')
               and   user                           = 'NGSUPPORT'
               and   owner                         !=  USER
               and   table_name not in (select synonym_name
                                        from user_synonyms)
               union
               (select owner||'_'||table_name table_name
                     , owner
               from all_tables
               where table_name in (select table_name
                                    from all_tables
                                    where (   substr(owner,3,length(owner)-5) = 'OWNER' 
                                           or substr(owner,3,length(owner)-5) = 'CRUISE')
                                    group by table_name
                                    having count(*) >1)
               and   (   substr(owner,3,length(owner)-5) = 'OWNER'
                      or substr(owner,3,length(owner)-5) = 'CRUISE')
               and   user                           = 'NGSUPPORT'
               minus
               select synonym_name
                     ,table_owner
               from user_synonyms);
               
  -- Identify object to create RDOWNERVN1 synonyms on
  cursor c4 is select distinct table_name
                              ,grantor
               from all_tab_privs
               where grantor    =        v_ref_owner
               and   user       not like 'RD%BS1'
               and   grantor    !=       USER
               and   table_name not in ('DEPLOYMENT_LABEL')
               and   table_name not in (select synonym_name
                                        from user_synonyms);

  -- Identify objects to create TIREADNG1 synonyms on
  cursor c5 is select distinct synonym_name  object_name
                              ,owner
               from all_synonyms
               where (   substr(owner,3) = 'OWNERBS1'
                      or substr(owner,3) = 'CRUISEBS1')
               and   user                = 'TIREADGN1'
               and   owner              !=  USER
               and   synonym_name not in (select synonym_name
                                          from user_synonyms)
               union
               select distinct table_name   object_name
                              ,owner
               from all_tables
               where (  substr(owner,1,2)||substr(owner,length(owner)-2) = 'TIBS1'
                     or substr(owner,1,2)||substr(owner,length(owner)-2) = 'RDBS1')
               and   table_name not in (select synonym_name 
                                        from user_synonyms)
               union
               select owner||'_'||object_name object_name
                     ,owner
               from all_objects
               where object_name in (select object_name
                                     from all_objects
                                     where (   substr(owner,3) = 'OWNERBS1'
                                            or substr(owner,3) = 'CRUISEBS1'
                                            or substr(owner,1,2)||substr(owner,length(owner)-2) = 'TIGN1')
                                     and object_type in ('TABLE','VIEW','SYNONYM')
                                     group by object_name
                                     having count(*) >1)
               and   (   substr(owner,3) = 'OWNERBS1'
                      or substr(owner,3) = 'CRUISEBS1')
               and   user                = 'TIREADGN1'
               minus
               select synonym_name
                     ,table_owner
               from user_synonyms;

  -- Identify TIREADGN1 synonyms to drop
  cursor c6 is select synonym_name
               from user_synonyms
               minus
              (select a.synonym_name
               from   user_synonyms a
                     ,all_tab_privs b
               where a.table_owner                  = b.grantor
               and   b.grantee                      = user
               and   a.synonym_name                 = b.table_name
               and  (   substr(b.grantor,1,2)||substr(b.grantor,length(b.grantor)-2) = 'RDVN1'
                     or substr(b.grantor,1,2)||substr(b.grantor,length(b.grantor)-2) = 'TIBS1')
               union 
               select b.grantor||'_'||a.synonym_name
               from   user_synonyms a
                     ,all_tab_privs b
               where a.table_owner                  = b.grantor
               and   b.grantee                      = USER
               and   a.synonym_name                 = b.table_name
               and  (   substr(b.grantor,1,2)||substr(b.grantor,length(b.grantor)-2) = 'RDVN1'
                     or substr(b.grantor,1,2)||substr(b.grantor,length(b.grantor)-2) = 'TIBS1')
               union
               select table_name
               from all_tables
               where substr(owner,1,2)||substr(owner,length(owner)-2) = 'TIBS1'
               union
               select owner||'_'||table_name
               from all_tables
               where substr(owner,1,2)||substr(owner,length(owner)-2) = 'TIBS1');

  -- Identify RDREADSNAP synonyms to drop
  cursor c7 is select synonym_name
               from user_synonyms
               where synonym_name not in ('RDDET_DELIVERY_TERMS'
                                         ,'RDGIG_GRD_IN_GRD_GROUPS'
                                         ,'RDGRD_GRADES'
                                         ,'RDGRG_GRADE_GROUPS'
                                         ,'RDGUC_GRADE_UNIT_CONVS');

  -- Identify objects to create RDREADSNAP synonyms on
  cursor c8 is select distinct table_name
                              ,grantor
               from all_tab_privs
               where grantor    =        'RDOWNERVN1'
               and   user       not like 'RD%BS1'
               and   grantor    !=       USER
               and   table_name not in ('DEPLOYMENT_LABEL')
               and   table_name not in (select synonym_name
                                        from user_synonyms)
               and   table_name in     ('RDDET_DELIVERY_TERMS'
                                       ,'RDGIG_GRD_IN_GRD_GROUPS'
                                       ,'RDGRD_GRADES'
                                       ,'RDGRG_GRADE_GROUPS'
                                       ,'RDGUC_GRADE_UNIT_CONVS');
 -- Identify objects to create NGREPORT synonyms on
   cursor c9 is select distinct table_name
                               ,owner
                from all_tables
                where (   substr(owner,3,length(owner)-5) = 'OWNER' 
                       or substr(owner,3,length(owner)-5) = 'CRUISE')
                and   user                           = 'NGREPORT'
                and   owner                         !=  USER
                and   table_name not in (select synonym_name
                                         from user_synonyms)
                union
                (select owner||'_'||table_name table_name
                      , owner
                from all_tables
                where table_name in (select table_name
                                     from all_tables
                                     where (   substr(owner,3,length(owner)-5) = 'OWNER' 
                                            or substr(owner,3,length(owner)-5) = 'CRUISE')
                                     group by table_name
                                     having count(*) >1)
                and   (   substr(owner,3,length(owner)-5) = 'OWNER'
                       or substr(owner,3,length(owner)-5) = 'CRUISE')
                and   user                           = 'NGREPORT'
                minus
                select synonym_name
                      ,table_owner
                from user_synonyms);

  -- Identify CSOWNERUP1 synonyms to drop
  cursor c10 is select synonym_name
               from user_synonyms
               where synonym_name not in ('CSUSR_USER_PREFERENCES'
                                         ,'CSUPD_USER_PREF_DEFAULTS'
                                         ,'FOUNTAIN_SEQ');

  -- Identify objects to create CSOWNERUP1 synonyms on
  cursor c11 is select distinct table_name
                              ,grantor
               from all_tab_privs
               where grantor    =        'CSOWNERBS1'
               and   user       not like 'CS%BS1'
               and   grantor    !=       USER
               and   table_name not in ('DEPLOYMENT_LABEL')
               and   table_name not in (select synonym_name
                                        from user_synonyms)
               and   table_name in     ('CSUSR_USER_PREFERENCES'
                                        ,'CSUPD_USER_PREF_DEFAULTS'
                                        ,'FOUNTAIN_SEQ');
  -- Identify Tibco NG synonyms to drop
  CURSOR c12 IS 
     SELECT synonym_name
     FROM   user_synonyms
     WHERE  synonym_name NOT LIKE 'ADB%'
     AND    synonym_name NOT LIKE 'NG%';

  -- Identify objects to create Tibco NG synonyms on
  CURSOR c13 IS
     SELECT DISTINCT table_name,
                     grantor
     FROM   all_tab_privs
     WHERE  grantor    LIKE     v_current_user_prefix||'%BS%'
     AND    user       NOT LIKE v_current_user_prefix||'%BS%'
     AND    grantor    !=       USER
     AND   (table_name LIKE 'ADB%'
            OR
            table_name LIKE 'NG%')
     AND    table_name NOT IN (SELECT synonym_name
                               FROM   user_synonyms)
     UNION
     SELECT DISTINCT table_name,
                     grantor
     FROM   all_tab_privs
     WHERE  grantor    LIKE     v_current_user_prefix||'%EC%'
     AND    user       NOT LIKE v_current_user_prefix||'%EC%'
     AND    grantor    !=       USER
     AND   (table_name LIKE 'ADB%'
            OR
            table_name LIKE 'NG%')
     AND    table_name NOT IN (SELECT synonym_name
                               FROM   user_synonyms)
     UNION
     SELECT DISTINCT table_name,
                     grantor
     FROM   all_tab_privs
     WHERE  grantor    LIKE     v_current_user_prefix||'%BS%'
     AND    user       NOT LIKE v_current_user_prefix||'%BS%'
     AND    grantor    !=       USER
     AND   (table_name LIKE 'ADB%'
            OR
            table_name LIKE 'NG%'
            OR
            table_name IN ('DEHLM_HEADLINE_MESSAGE',
                           'DEHLM_HEADLINE_MESSAGE_P',
                           'DETRE_TRACKING_EVENTS',
                           'DETRE_TRACKING_EVENTS_P'))
     AND    table_name NOT IN (SELECT synonym_name
                               FROM   user_synonyms);
  
  procedure p_drop_synonyms(v_synonym_name varchar2)
  is
    v_sql     varchar2(100);
  begin
    v_sql := 'drop synonym "'||v_synonym_name||'"';
    dbms_output.put_line(v_sql);

    execute immediate v_sql;

  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_drop_synonyms;

  procedure p_gen_rd_synonyms(v_table_name varchar2, v_grantor varchar2)
  is
    v_sql     varchar2(100);
  begin
    v_sql := 'create synonym '|| RPAD(v_table_name,30,' ') ||' for '|| v_grantor ||'.'|| v_table_name;
    dbms_output.put_line(v_sql);

    execute immediate v_sql;

  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_gen_rd_synonyms;

  procedure p_gen_support_synonyms(v_object_name varchar2, v_owner varchar2)
  is
    v_sql      varchar2(100);
    v_chk_tab  number;
    v_obj_name varchar2(40);
  begin

    select count(*)
    into v_chk_tab
    from all_objects
    where object_type in ('TABLE','VIEW')
    and   (substr(owner,3,length(owner)-5) = 'OWNER'
        or substr(owner,3,length(owner)-5) = 'CRUISE'
        or substr(owner,3,length(owner)-5) = 'DEV'
        or substr(owner,3,length(owner)-5) = 'PAD')
    and   object_name = v_object_name;


    if v_chk_tab = 0
    then

      v_obj_name := substr(replace(v_object_name,v_owner,(substr(v_owner,1,2)||substr(v_owner,length(v_owner)-2))),1,30);

      select count(*)
      into v_chk_tab
      from user_synonyms
      where synonym_name = v_obj_name;

      if v_chk_tab = 0
      then
        v_sql := 'create synonym '|| RPAD(v_obj_name,30,' ') ||' for '|| v_owner ||'.'|| replace(v_object_name,v_owner||'_','');
        execute immediate v_sql;
      end if;
    elsif v_chk_tab = 1
    then
      v_sql := 'create synonym '|| RPAD(v_object_name,30,' ') ||' for '||v_owner||'.'||v_object_name;
      execute immediate v_sql;
    end if;

    dbms_output.put_line(v_sql);

  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');

  end p_gen_support_synonyms;

begin
  if v_user_type = 'OWNER'
  or v_user_type = 'CRUISE'
  or v_user_type = 'DEV'
  or v_user_type = 'PAD'
  then

    dbms_output.put_line('###### Dropping redundant synonyms for '||user||' ######');

    if user != 'TIREADGN1'       and
       v_current_user_suffix != 'TB'
    then
      for v1 in c1
      loop
        p_drop_synonyms(v1.synonym_name);
      end loop;
    end if;

    if v_current_user_suffix = 'TB'
    then
      for v12 in c12
      loop
        p_drop_synonyms(v12.synonym_name);
      end loop;
    end if;

    if  v_current_user        != 'BOBS1' and
        v_current_user        != 'TBBS1' and
        v_current_user_suffix != 'TB'
    then
      dbms_output.put_line(chr(10)||'###### Creating synonyms for '||user||' schema ######'||chr(10));

      for v2 in c2
      loop
        p_gen_rd_synonyms(v2.table_name, v2.grantor);
      end loop;
    end if;

    if v_current_user         = 'RDVN1' and
       v_current_user_suffix != 'TB'
    then
      dbms_output.put_line(chr(10)||'###### Creating synonyms for '||user||' schema ######'||chr(10));

      for v4 in c4
      loop
        p_gen_rd_synonyms(v4.table_name, v4.grantor);
      end loop;
    end if;
  end if;

  if user = 'NGSUPPORT'
  then
    for v3 in c3
    loop
      p_gen_support_synonyms(v3.table_name, v3.owner);
    end loop;
  end if;

  if user = 'NGREPORT'
  then
    for v9 in c9
    loop
      p_gen_support_synonyms(v9.table_name, v9.owner);
    end loop;
  end if;

  if user = 'TIREADGN1'
  then
    dbms_output.put_line(chr(10)||'###### Dropping synonyms from '||user||' schema ######'||chr(10));

    for v6 in c6
    loop
      p_drop_synonyms(v6.synonym_name);
    end loop;

    dbms_output.put_line(chr(10)||'###### Creating synonyms for '||user||' schema ######'||chr(10));

    for v5 in c5
    loop
      p_gen_support_synonyms(v5.object_name, v5.owner);
    end loop;
  end if;

  if user = 'RDREADSNAP'
  then
    dbms_output.put_line(chr(10)||'###### Dropping synonyms for '||user||' schema ######'||chr(10));
    for v7 in c7
    loop
      p_drop_synonyms(v7.synonym_name);
    end loop;

    dbms_output.put_line(chr(10)||'###### Creating synonyms from '||user||' schema ######'||chr(10));

    for v8 in c8
    loop
      p_gen_rd_synonyms(v8.table_name, v8.grantor);
    end loop;
  end if;

  if user = 'CSOWNERUP1'
  then
    dbms_output.put_line(chr(10)||'###### Dropping synonyms for '||user||' schema ######'||chr(10));
    for v10 in c10
    loop
      p_drop_synonyms(v10.synonym_name);
    end loop;

    dbms_output.put_line(chr(10)||'###### Creating synonyms from '||user||' schema ######'||chr(10));

    for v11 in c11
    loop
      p_gen_rd_synonyms(v11.table_name, v11.grantor);
    end loop;
  end if;

  IF v_current_user_suffix = 'TB' THEN

    DBMS_OUTPUT.put_line(chr(10)||'###### Creating synonyms from '||user||' schema ######'||chr(10));
    FOR v13 IN c13
    LOOP

      p_gen_rd_synonyms (v13.table_name, v13.grantor);

    END LOOP;

  END IF;

exception
when others
then
  dbms_output.put_line('###### Unhandled exception ######');
end;
/
