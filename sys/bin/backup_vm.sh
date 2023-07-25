##
# $Header: /jbs/var/cvs/homeutils/bin/backup_vm.sh,v 1.1.1.1 2012/12/27 22:35:08 jim Exp $
#
# $Log: backup_vm.sh,v $
# Revision 1.1.1.1  2012/12/27 22:35:08  jim
# First import
#
# Revision 1.1  2012/05/22 07:55:13  jim
# First checkin after import
#
# Revision 1.2  2006/03/09 14:48:54  jim
# Added more logging a initial support for configuration files
#
# Revision 1.1.1.1  2006/03/09 13:33:32  jim
# Initial import of vmware support utilities
#
#
# ===================================================================
#
# Hard code some defaults
#

debug_echo() {
 if [ "${DEBUG}" == "TRUE" ]
 then
  echo $*
 fi
}

SCRIPTPATH=$(dirname $_)

TEMPBACKUPDIR=/cygdrive/d/vm
TEMPSOURCEDIR="/cygdrive/d/Virtual"
TEMPCONFIGFILENAME=vmutils.conf

#debug_echo "1=${1}="
#debug_echo "2=${2}="
#debug_echo "3=${3}="

#
# Now find a config file if there is one.
# A series of config files are sourced
# in a global-local order.
#
# This means that local config files
# only need to specify changed settings
# rather than all settings.
#

GLOBALCONFIGFILENAME="$(dirname ${SCRIPTPATH})/etc/${TEMPCONFIGFILENAME}"

if [ -f ${GLOBALCONFIGFILENAME} ]
then
 . ${GLOBALCONFIGFILENAME}
fi
if [ -f ./${TEMPCONFIGFILENAME} ]
then
 . ./${TEMPCONFIGFILENAME}
fi

# 
# Now ensure that mandatory settings are set
#
if [ "${BACKUPDIR}" == "" ]
then
 BACKUPDIR=${TEMPBACKUPDIR}
fi
if [ "${SOURCEDIR}" == ""  ]
then
 SOURCEDIR=${TEMPSOURCEDIR}
fi

#debug_echo G1  $GLOBALSETTING1
#debug_echo G2  $GLOBALSETTING2
#debug_echo L1  $LOCALSETTING1



NEEDBACKUP=FALSE

BACKUPFILE=${BACKUPDIR}/${2}
SOURCEDIR=${1}
VM=${2}

TARFILE=${BACKUPFILE}.tar
GZIPFILE=${BACKUPFILE}.gz
TGZFILE=${BACKUPFILE}.tgz

echo "backup_vm.sh(1):Backing up ${1} ${2}"
# 
# is there somewhere to backup to?
#
if [ ! -d ${BACKUPDIR} ]
then
 echo "No backup repository (${BACKUPDIR})"
 exit 1
fi


#
# Is there somewhere to backup from?
#
if [ ! -d "${SOURCEDIR}" ]
then
 echo "No VM repository (${SOURCEDIR})"
 exit 1
fi

#debug_echo "backup_vm.sh:Backing up ${2} in ${1}"

cd "${SOURCEDIR}"

#
# Does the VM exist?
#
#debug_echo "backup_vm.sh:Backing up ${2} from ${2}"
if [ ! -d ${2} ]
then
 echo "No virtual machine (${2})"
 exit 1
fi


for x in "${SOURCEDIR}/${VM}"/*
do
 debug_echo -n ${x}
 if [ ! -f "${x}"  ]
 then 
   debug_echo -n " doesn't exist "
 else 
   debug_echo -n " exists"
 fi
#debug_echo "backup_vm.sh(9):Backing up ${SOURCEDIR}/${VM}/${x} to compressed file ${TGZFILE}"
 if [ "${x}" -nt ${TGZFILE}  ]
 then
  NEEDBACKUP=TRUE
  debug_echo " and is newer"
 else 
  debug_echo " and is older "
 fi
done
#debug_echo "NEEDBACKUP=${NEEDBACKUP}"
if [ ${NEEDBACKUP} == TRUE ]
then
#debug_echo "backup_vm.sh:Backing up ${1} ${2} (again again again again)"

    DIRSIZE=$(du -sk ${2} | awk '{ print $1 }')
    echo "${1} Files changed, backing up ${DIRSIZE}KB to ${TGZFILE}"
    
#    echo "Tar piped through gzip"
#    tar cvf - ${1} | gzip >${GZIPFILE}
#    echo "Plain tar"
#    tar cvf ${TARFILE} ${1}
#    echo "Compressed tar" 
    echo "Backup started at $(date)"
    tar cvzf ${TGZFILE} ${2}
    RETVAL=$?
    BCKBYTES=$(ls -l ${TGZFILE} | awk '{ print $5 }')
    BCKKBYTES=(BCKBYTES/1024)
    if [ ${RETVAL} -ne 0 ]
    then
	echo "Backup failed at $(date) - size ${BCKBYTES}"
	exit ${RETVAL}
    else 
	echo "Backup finished at $(date) - size ${BCKBYTES}"
	exit 0
    fi
fi

debug_echo() {
 if [ "${DEBUG}" == "TRUE" ]
 then
  echo $*
 fi
}