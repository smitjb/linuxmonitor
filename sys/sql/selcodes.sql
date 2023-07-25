select substr(rdcod_pk,1,16) rdcod_pk, substr(name, 1,60) name
from rdcod_codes
where name in ( 'AMERICAN', 'EUROPEAN', 'ASIAN');


select substr(rddlt_pk,1,16) rddlt_pk,
       substr(description,1,60) description
from   RDDLT_DEAL_TYPES        RDDLT1
where  description like '%FLOAT%';

 rdcdt_code_types
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 RDCDT_PK                                  NOT NULL NUMBER(16)
 NAME                                      NOT NULL VARCHAR2(12)
 USER_MAINTAINED                           NOT NULL CHAR(1)
 LOCK_NUM                                  NOT NULL NUMBER(16)
 VALID_FROM                                NOT NULL DATE
 LAST_UPDATE_TIME                          NOT NULL DATE
 LAST_UPDATE_USER                          NOT NULL NUMBER(16)
 NAME_FIELD_LENGTH                         NOT NULL NUMBER(2)
 LONG_NAME                                          VARCHAR2(24)
 DESCRIPTION                                        VARCHAR2(255)
 VALID_TO                                           DATE
 DELETED_ROW                                        DATE

Enter value for table: rdcod_codes
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 RDCOD_PK                                  NOT NULL NUMBER(16)
 CODE_TYPE_RDCDT_FK                        NOT NULL NUMBER(16)
 NAME                                      NOT NULL VARCHAR2(24)
 LOCK_NUM                                  NOT NULL NUMBER(16)
 VALID_FROM                                NOT NULL DATE
 LAST_UPDATE_TIME                          NOT NULL DATE
 LAST_UPDATE_USER                          NOT NULL NUMBER(16)
 LONG_NAME                                          VARCHAR2(24)
 DESCRIPTION                                        VARCHAR2(255)
 VALID_TO                                           DATE
 DELETED_ROW                                        DATE


:wq

