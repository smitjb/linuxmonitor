cd /cygdrive/o/smi425

rm -rf deploy
mkdir -p deploy/lib

cd /cygdrive/m/smi425_main_latest/gio_dba/oracle/PerlModules

scp -r * /cygdrive/o/smi425/deploy/lib

cd /cygdrive/m/smi425_main_latest/gio_dba/oracle/scripts/Utilities

scp -r etc lib shell log ddl sql /cygdrive/o/smi425/deploy



