ssh -l ${1} ${2} mkdir -p ${3}/lib

cd /cygdrive/m/smi425_main_latest/gio_dba/oracle/PerlModules

scp -r * ${1}@${2}:${3}/lib

cd /cygdrive/m/smi425_main_latest/gio_dba/oracle/scripts/Utilities

scp -r etc lib shell log ddl sql tests ${1}@${2}:${3}


