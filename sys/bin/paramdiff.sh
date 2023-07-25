
sqlplus utl_dba/york1ham@$1 <<EOF
set linesize 500
set pagesize 1000
col value format a100
col name format a50
spool $1.params
select name, value from v\$parameter;
spool off
EOF
sqlplus utl_dba/york1ham@$2 <<EOF
set linesize 500
set pagesize 1000
col value format a100
col name format a50
spool $2.params
select name, value from v\$parameter;
spool off
EOF

diff $1.params $2.params
