


function backup_primary() {
#
# back up the pimary database
# create the standby control file
#
backup_location="/backup"
sqlplus "/ as sysdba" <<EOF
set heading off
set feedback off
set echo off
set linesize 200
set pagesize 0
spool $backup_location/backup_data_files.sh
select 'compress <'||name ||' >$backup_location/$ORACLE_SID/'||substr(name,instr(name,'/',-1)+1)||'.Z' from v\$datafile;
spool $backup_location/restore_data_files.sh
select 'uncompress <$backup_location/$ORACLE_SID/'||substr(name,instr(name,'/',-1)+1)||'.Z >'||name from v\$datafile;
spool off
EOF

if [ -f $backup_location/backup_data_files.sh ];then

sqlplus "/ as sysdba" <<EOF
shutdown immediate
exit
EOF
fi

ksh $backup_location/backup_data_files.sh

sqlplus "/ as sysdba" <<EOF
startup
alter database create standby controlfile as $backup_location/$ORACLE_SID/$ORACLE_SID_stby_control.ctl;
shutdown
exit
EOF
fi

}

function get_files(){
#
# pull the files over from the primary
#
# Parameters
# 1 source machine
# 2 location on source machine
# 3 location on local machine
# #####################################

scp -r oracle@${1}:${2} ${3}

}

function restore_standby() {
#
# Put the control file in place
# restore the data files and logs
#
# Parameters
# 1 backup location
# 2 name of init.ora for standby database
# =======================================================
#
# Restore the data files using the script generated during backup
#

ksh $1/restore_data_files.sh

#
# Copy the standby control file to each control file
#
CTLFILES=$(cat $2 | grep -control_files | awk -F= '{ print $2 }'
for ctlfile in ${CTLFILES}
do
 cp $1/$ORACLE_SID_stby_control.ctl $ctlfile
done 

}


function 
