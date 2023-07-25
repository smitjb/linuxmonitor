select * from dba_synonyms
where ( owner,synonym_name ) in
(select owner, object_name
 from dba_objects
 where object_type ='SYNONYM' AND status='INVALID'
 and owner like upper('%&1%'));

