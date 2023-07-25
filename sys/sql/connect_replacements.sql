--
-- generate system privileges for users who had the connect role in 8i/9i/10gR1 and 
-- who may need to retain these privileges post 10gR2 upgrade
-- ===========================================================================
  select distinct 'grant create '||
  decode(object_type,
     'PACKAGE','procedure',
     'PACKAGE BODY','procedure',
     'FUNCTION','procedure',
     object_type)
  ||' to '||drp.grantee||';'
  from dba_sys_privs dsp,
   dba_role_privs drp,
  dba_objects
  where dsp.grantee='CONNECT'
  and drp.grantee in ( SELECT grantee FROM dba_role_privs
                     WHERE granted_role = 'CONNECT' and
                     grantee NOT IN (
                     'SYS', 'OUTLN', 'SYSTEM', 'CTXSYS', 'DBSNMP',
                      'LOGSTDBY_ADMINISTRATOR', 'ORDSYS',
                      'ORDPLUGINS',  'OEM_MONITOR', 'WKSYS', 'WKPROXY',
                      'WK_TEST', 'WKUSER', 'MDSYS', 'LBACSYS', 'DMSYS',
                      'WMSYS',  'OLAPDBA', 'OLAPSVR', 'OLAP_USER',
                      'OLAPSYS', 'EXFSYS', 'SYSMAN', 'MDDATA',
                      'SI_INFORMTN_SCHEMA', 'XDB', 'ODM'))
and owner=drp.grantee
/