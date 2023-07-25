set ORACLE_UNQNAME=OTRND1
call emctl stop dbconsole
sqlplus "/ as SYSDBA" @localshutdown
lsnrctl stop
