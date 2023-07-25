-- #############################################################################
-- # Name   : gen_apply_grants.sql
-- # Author : Andrew Morris
-- # Date   : August 2003
-- # Purpose:
-- # Calling routine:
-- # Called routine:
-- # Parameter files:
-- # Notes  : Removes redundant grants, and adds all appropriate grants
-- # Usage  : Connect as owning schemas
-- # Modified:
-- # By          When     Change
-- # ----------- -------- ------------------------------------------------------
-- # AR Morris   03/12/03 Added grants to RDREADSNAP
-- # J Kaminski  16/6/04  Added NGREPORT piece
-- # J Kaminski  17/6/04  Add extra grants for csownerup1
-- # J Kaminski  17/6/04  Add extra grants for csownerup1
-- # Des Fox     03/03/05 Add ADB and NG table synonyms for ownerTB schemas - TIBCO ADB security CR
-- # Des Fox     16/03/05 Additionad tables for deal schemas for TIBCO-ADB security fix.
-- #                      tables - dehlm_headline_message,dehlm_headline_message_p,
-- #                      detre_tracking_events,detre_tracking_events_p
-- #############################################################################
set serveroutput on size 1000000
set linesize 120

declare

  v_table_owner         varchar2(11) := 'RD'||substr(user,3,length(user)-5)||'BS1';
  v_current_user        varchar2(5)  := substr(user,1,2)||substr(user,length(user)-2);
  v_current_user_suffix varchar2(2)  := substr(user,length(user)-2,2);
  v_current_user_prefix varchar2(2)  := substr(user,1,2);
  v_user_type           varchar2(6)  := substr(user,3,length(user)-5);
  v_target_user         varchar2(11);
  v_cgas_user           number;
  v_ez_user             number;
  v_ng_username         varchar2(11);

  -- Cursor to revoke excess / wrong grants
  cursor c0 is select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where privilege    !=       'SELECT'
               and   grantor      not like 'RD%BS1'
               and   grantee      !=        user
               and   table_name   not like 'SC%'
               and   table_name   not in  ('WIP','NGPUB_PUB_EVENTS','NGPUB_NEXTID','NGSYSDATE')
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where grantor      not like 'RD%BS1'
               and   grantor      not like 'RD%VN1'
               and   grantee      !=        user
               and   grantee      !=       'NGSUPPORT'
               and   grantee      !=       'NGREPORT'
               and   grantee      !=       'RDREADSNAP'
               and   grantee      !=       'TIREADGN1'
               and   table_name   not in  ('WIP','NGPUB_PUB_EVENTS','NGPUB_NEXTID','NGSYSDATE')
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where (privilege not in    ('SELECT','UPDATE','EXECUTE')
               and   (    grantor like     'RD%BS1'
                      or  grantor not like 'RD%VN1'))
               and   grantee      !=        user
               and   grantable    !=       'NO'
               and   table_name   like     'SC%'
               and   table_name   !=       'SCPWH_PASSWORD_HISTORY'
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where (privilege   not in  ('SELECT','UPDATE','EXECUTE')
               and   (    grantor like     'RD%BS1'
                      or  grantor not like 'RD%VN1'))
               and   grantee      !=        user
               and   grantable     =       'YES'
               and   table_name   not like 'SC%'
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where grantor       =        user
               and   grantee      !=        user
               and   grantee      not like 'RD%VN1'
               and   grantable     =       'YES'
               and   table_name   not like 'SC%'
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where privilege    not in  ('SELECT')
               and   grantor      =     user
                     and   table_name not like 'SC%'
               and  (grantee      not like 'RD%VN1'
                     or      table_name not like 'SC%')
               and   grantee     !=         user
               and   grantable    =        'YES'
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where grantee     !=         user
               and   grantor      =         user
               and  (grantee     not like  'RD%VN1'
                     and   table_name not like 'SC%')
               and   grantable    =        'YES'
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where grantor     not like  'RD%BS1'
               and   grantor     =          user
               and   grantee    !=          user
               and   grantable   =         'YES'
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where (grantee    =         'NGSUPPORT'
                      or grantee =         'NGREPORT'
                      or grantee =         'RDREADSNAP'
                      or grantee =         'TIREADGN1')
               and   privilege  !=         'SELECT'
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee
               from user_tab_privs
               where user       like       'RD%BS1'
               and   (      grantee not like '%VN1'
                      and   grantee not like '%VN2')
               and   grantee    not in    ('NGSUPPORT'
                                          ,'NGREPORT'
                                          ,'RDREADSNAP'
                                          ,'TIREADGN1')
               and   grantor    =           user
               union
               select 'revoke '||privilege||' on '|| RPAD(table_name,30,' ') ||' from '||grantee    V_SQL
               from user_tab_privs
               where grantee    =         'RDREADSNAP'
               and   user       not like  'RD%VN1'
               and   table_name not in   ('RDDET_DELIVERY_TERMS'
                                         ,'RDGIG_GRD_IN_GRD_GROUPS'
                                         ,'RDGRD_GRADES'
                                         ,'RDGRG_GRADE_GROUPS'
                                         ,'RDGUC_GRADE_UNIT_CONVS');

  -- Identify missing synonyms
  cursor c1 is select object_name
               from all_objects
               where (object_name like 'RD%'
                      or object_name like 'SC%')
               and   object_type in ('TABLE','VIEW','SEQUENCE')
               and   owner       = v_table_owner
               and   object_name not in (select synonym_name
                                         from user_synonyms);

  -- Cursor to identify object owners
  cursor c2 is select username
               from all_users
               where (username    like '%OWNER%'
                      or username like '%CRUISE%'
                      or username like '%DEV%'
                      or username like '%PAD%')
               and   username !=       'CRUISE'
               and   username !=       'CRUISE_EXP'
               and   username not like '%VN1'
               and   username not like '%VN2'
               and   (   substr(user,3,length(username)-5) = substr(username,3,length(user)-5));

  -- Cursor used to identify all objects to grant on 
  cursor c3 is select object_name
               from user_objects
               where object_type in ('TABLE','VIEW','SEQUENCE');

  -- Cursor used to identify all objects for RDVN1 to grant on 
  cursor c4 is select object_name
               from all_objects
                   ,user_synonyms
               where (object_name like 'RD%'
                       or object_name like 'SC%')
               and   object_type in ('TABLE','VIEW')
               and   owner       = v_table_owner
               and   object_name = synonym_name;

  -- Cursor used to identify all non-RDVN1 objects to grant on 
  cursor c5 is select object_name, object_type
               from user_objects
               where object_type = 'FUNCTION'
               or    object_name in ('WIP'
                                    ,'NGPUB_PUB_EVENTS');

  -- Cursor used to grant to ngsupport
  cursor c6 is select object_name
               from user_objects
               where object_type in ('TABLE','VIEW');

  -- Cursor used to grant to RDREADSNAP on selected objects
  cursor c7 is select object_name
               from all_objects
               where object_type in ('TABLE','VIEW')
               and   owner       =   'RDOWNERBS1'
               and   object_name in ('RDDET_DELIVERY_TERMS'
                                    ,'RDGIG_GRD_IN_GRD_GROUPS'
                                    ,'RDGRD_GRADES'
                                    ,'RDGRG_GRADE_GROUPS'
                                    ,'RDGUC_GRADE_UNIT_CONVS');

  -- Cursor used to grant to CSOWNERUP1 on selected objects
  cursor c8 is select object_name
               from   all_objects
               where  object_type in ('TABLE','SEQUENCE')
               and    owner       =   'CSOWNERBS1'
               and    object_name in ('CSUSR_USER_PREFERENCES'
                                     ,'CSUPD_USER_PREF_DEFAULTS'
                                     ,'FOUNTAIN_SEQ');

  -- Identify objects to create RDOWNERNG1 synonyms on
  CURSOR c9 IS
     SELECT object_name
     FROM   all_objects
     WHERE  owner          = user
     AND    object_type    = 'TABLE'
     AND   (object_name LIKE 'ADB%'
            OR
            object_name LIKE 'NG%')
     AND    owner         IN ('RDOWNERBS1', 'DEOWNERBS1', 'TIOWNERBS1', 'CSOWNERBS1', 'TBOWNEREC1',
                              'RDCRUISEBS1','DECRUISEBS1','TICRUISEBS1','CSCRUISEBS1','TBCRUISEEC1',
                              'CGOWNERBS1', 'CGOWNERBS2', 'CGOWNERBS3',
                              'CGCRUISEBS1','CGCRUISEBS2','CGCRUISEBS3')
     UNION
     SELECT object_name
     FROM   all_objects
     WHERE  owner          = user
     AND    object_type    = 'TABLE'
     AND    object_name IN ('DEHLM_HEADLINE_MESSAGE','DEHLM_HEADLINE_MESSAGE_P','DETRE_TRACKING_EVENTS','DETRE_TRACKING_EVENTS_P')
     AND    owner       IN ('DEOWNERBS1','DECRUISEBS1');

  -- Revoke excess ref object owner grants ONLY

  procedure p_revoke_ref_grants(v_sql varchar2)
  is
  begin
    execute immediate v_sql;  
    dbms_output.put_line(v_sql);
  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_revoke_ref_grants;

  -- Ref object owner grants ONLY
  procedure p_grant_ref(v_object_name varchar2)
  is
    v_sql     varchar2(100);
    v_grantee varchar2(11) := 'RD'||v_user_type||'VN1';
  begin
    if substr(v_object_name,1,2) != 'SC'
    then
      v_sql := 'grant select on '|| RPAD(v_object_name,30,' ') ||' to '||v_grantee||' with grant option';
    elsif substr(v_object_name,1,2) = 'SC'
    then
      if v_object_name = 'SCPWH_PASSWORD_HISTORY'
      then
        v_sql := 'grant select, insert, update on '|| RPAD(v_object_name,30,' ') ||' to '||v_grantee||' with grant option';
      else
        v_sql := 'grant select, update on '|| RPAD(v_object_name,30,' ') ||' to '||v_grantee||' with grant option';
      end if;
    end if;

    dbms_output.put_line(v_sql);
    execute immediate v_sql;

    if v_object_name not like '%_SEQ'
    then
      v_sql := 'grant select, insert, update, delete on '|| RPAD(v_object_name,30,' ') ||' to '||v_grantee;
      dbms_output.put_line(v_sql);
      execute immediate v_sql;
    end if;
  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_grant_ref;

  -- Ref synonym grants ONLY
  procedure p_grant_applications(v_username varchar2, v_object_name varchar2)
  is

    v_sql varchar2(100);
    v_obj varchar2(30);

  begin
    v_obj := v_object_name;

    if substr(v_object_name,1,2) = 'RD'
    then
      v_sql := 'grant select on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;
    elsif substr(v_object_name,1,2) = 'SC'
    then
      if v_object_name = 'SCPWH_PASSWORD_HISTORY'
      then
        v_sql := 'grant select, insert, update on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;
      else
        v_sql := 'grant select, update on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;
      end if;
    end if;

    execute immediate v_sql;
    dbms_output.put_line(v_sql);

  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_grant_applications;


  -- Additional CG grants ONLY
  procedure p_grant_additional(v_username varchar2, v_object_name varchar2, v_object_type varchar2)
  is
    v_sql varchar2(100);
  begin
    if v_object_type = 'FUNCTION'
    then
      v_sql := 'grant execute on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;
    else
      v_sql := 'grant select, insert, update, delete on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;
    end if;

    execute immediate v_sql;
    dbms_output.put_line(v_sql);

  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_grant_additional;

  -- Generate support grants
  procedure p_support_grants(v_username varchar2, v_object_name varchar2)
  is
    v_sql varchar2(100);
    v_usr varchar2(2);
  begin
    v_usr := substr(v_username,1,2);
    v_sql := 'grant select on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;

    -- Only grant to OWNER
    if v_user_type = 'OWNER'
    then
      if v_usr = 'TI'
      then
        -- Grant select on TIS objects, or RDOWNERBS1 to tireadgn1
        if substr(v_object_name,1,2) = 'TI'
        or (     user        like 'RD%BS1'
            and  v_user_type =    'OWNER') 
        then
          execute immediate v_sql;
          dbms_output.put_line(v_sql);
        end if;
      else
        execute immediate v_sql;
        dbms_output.put_line(v_sql);
      end if;
    end if;
  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_support_grants;

  -- Generate csownerup1 grants
  procedure p_csownerup1_grants(v_username varchar2, v_object_name varchar2)
  is
    v_sql varchar2(100);
    v_usr varchar2(2);
  begin
    v_usr := substr(v_username,1,2);
    if v_object_name = 'CSUSR_USER_PREFERENCES'
    then
      v_sql := 'grant select, insert, update, delete on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;
    else if v_object_name = 'CSUPD_USER_PREF_DEFAULTS'
    then
      v_sql := 'grant select, update on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;
    else if v_object_name = 'FOUNTAIN_SEQ'
    then
      v_sql := 'grant select on '|| RPAD(v_object_name,30,' ') ||' to '||v_username;
    end if;
    end if;
    end if;
    
    -- Only grant to OWNER
    if v_user_type = 'OWNER'
    then
      if v_usr = 'CS'
      then
        execute immediate v_sql;
        dbms_output.put_line(v_sql);
      end if;
    end if;
  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_csownerup1_grants;

  -- Additional CG grants ONLY
  procedure p_grant_tibco_ng (v_username    varchar2, 
                              v_object_name varchar2) is

    v_sql varchar2(100);
  begin
    
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON '|| RPAD(v_object_name,30,' ') ||' TO '||v_username;

    execute immediate v_sql;
    dbms_output.put_line(v_sql);

  exception
  when others
  then
    dbms_output.put_line('###### Error issuing: '||v_sql||' ######');
  end p_grant_tibco_ng;

begin

  if v_user_type = 'OWNER'
  or v_user_type = 'CRUISE'
  or v_user_type = 'DEV'
  or v_user_type = 'PAD'
  then
    dbms_output.put_line('###### Removing excess grants from RD'||v_user_type||'BS1 user ######'||chr(10));
    for v0 in c0
    loop
      p_revoke_ref_grants(v0.v_sql);
    end loop;

    -- Apply RD%VN1 grants 
    if v_current_user = 'RDVN1'
    then
      -- Check to see if all synonyms are present
      dbms_output.put_line(chr(10)||'###### Applying grants to RD'||v_user_type||'VN1 user ######'||chr(10));
      for v1 in c1
      loop
        dbms_output.put_line('###### No synonym exists for '||v_table_owner||'.'||v1.object_name||' ######');
      end loop;

      -- Apply grants. Loop through the appropriate users
      for v2 in c2
      loop
        -- Loop through the appropriate objects...
        dbms_output.put_line(chr(10)||'###### Applying grants for '||v2.username||' ######');
        for v4 in c4
        loop
          p_grant_applications(v2.username, v4.object_name);
        end loop;
      end loop;

    -- Apply RD%BS1 grants 
    elsif v_current_user = 'RDBS1'
    then
      dbms_output.put_line(chr(10)||'###### Applying grants to RD'||v_user_type||'BS1 user ######'||chr(10));

      for v3 in c3
      loop
        p_grant_ref(v3.object_name);
      end loop;
    end if;

    -- Apply additional contractgen grants 
    if substr(v_current_user,1,4) = 'CGBS'
    then

      dbms_output.put_line(chr(10)||'###### Applying grants to CG'||v_user_type||'BS1 user ######'||chr(10));

      select count(*)
      into v_cgas_user
      from all_users
      where username like 'CGOWNERAS%';

      select count(*)
      into v_ez_user
      from all_users
      where (   username = 'EZPOWER'
             or username = 'EZCRUISE');

      dbms_output.put_line(chr(10)||'###### Applying grants to CG'||v_user_type||'AS1 user ######'||chr(10));

      for v5 in c5
      loop
        if v_cgas_user > 0
        then
          v_target_user := 'CG'||v_user_type||'AS'||substr(user,length(user));
          p_grant_additional(v_target_user, v5.object_name, v5.object_type);
        end if; 

        if v_ez_user > 0
        then
          dbms_output.put_line(chr(10)||'###### Applying grants to EZ'||v_user_type||' user ######'||chr(10));

          if v_user_type  = 'CRUISE'
          then
            v_target_user := 'EZCRUISE';
          elsif v_user_type  = 'OWNER'
          then
            v_target_user := 'EZPOWER';
          end if;

          p_grant_additional(v_target_user, v5.object_name, v5.object_type);
        end if; 

      end loop;
    end if;

    -- Apply support user grants
    if v_current_user = 'RDBS1'
    or v_current_user = 'TIBS1'
    then
      dbms_output.put_line(chr(10)||'###### Applying grants to NGSUPPORT, NGREPORT and TIREADGN1 users ######'||chr(10));
    else
      dbms_output.put_line(chr(10)||'###### Applying grants to NGSUPPORT and NGREPORT user ######'||chr(10));
    end if;

    for v6 in c6
    loop
      p_support_grants('NGSUPPORT',v6.object_name);
      p_support_grants('NGREPORT',v6.object_name);
      if v_current_user = 'RDBS1'
      or v_current_user = 'TIBS1'
      then
        p_support_grants('TIREADGN1',v6.object_name);
      end if;
    end loop;

    -- Apply support user grants
    dbms_output.put_line(chr(10)||'###### Applying grants to RDREADSNAP user ######'||chr(10));

    for v7 in c7
    loop
      if v_current_user = 'RDVN1'
      then
        p_support_grants('RDREADSNAP',v7.object_name);
      end if;
    end loop;
                                    
   for v8 in c8
   loop
     if v_current_user = 'CSBS1'
     then
       p_csownerup1_grants('CSOWNERUP1',v8.object_name);
     end if;
   end loop;

   dbms_output.put_line(chr(10)||'###### Applying grants to Tibco NG user ######'||chr(10));
   for v9 in c9
   loop

       if    v_user_type = 'OWNER'  then
             v_ng_username := substr(user,1,2) || v_user_type || 'TB' || substr(user,10,1);

       elsif v_user_type = 'CRUISE' then
             v_ng_username := substr(user,1,2) || v_user_type || 'TB' || substr(user,11,1);
       
       end if;

       p_grant_tibco_ng (v_ng_username,v9.object_name);

   end loop;

  end if;
end;
/
