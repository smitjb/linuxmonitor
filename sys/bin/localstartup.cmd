set ORACLE_UNQNAME=OTRND1
lsnrctl start
sqlplus "/ as sysdba" @localstartup
call emctl start dbconsole