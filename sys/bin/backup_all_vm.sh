##
# $Header: /jbs/var/cvs/homeutils/bin/backup_all_vm.sh,v 1.1.1.1 2012/12/27 22:35:08 jim Exp $
#
# $Log: backup_all_vm.sh,v $
# Revision 1.1.1.1  2012/12/27 22:35:08  jim
# First import
#
# Revision 1.1  2012/05/22 07:55:13  jim
# First checkin after import
#

# ===================================================================
#
# Hard code some defaults
#
#set -x
SCRIPTPATH=$(dirname $_)
SCRIPTPATH=/cygdrive/c/var/dev/vmwutils/bin

TEMPSOURCEDIR="/cygdrive/d/Virtual"
TEMPCONFIGFILENAME=vmutils.conf
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
if [ "${SOURCEDIR}" == ""  ]
then
 SOURCEDIR=${TEMPSOURCEDIR}
fi

#echo G1  $GLOBALSETTING1
#echo G2  $GLOBALSETTING2
#echo L1  $LOCALSETTING1
echo !${SOURCEDIR}!
for SRCDIR in "/cygdrive/c/Virtual" "/cygdrive/d/Virtual"  #${SOURCEDIR}
do
echo "Backing up ${SRCDIR}"
#
# Is there somewhere to backup from?
#
if [ ! -d "${SRCDIR}" ]
then
 echo "No VM repository (${SRCDIR})"
 exit 1
fi

pushd "${SRCDIR}"
VMLIST=$(ls)

#cd ${SCRIPTPATH}
popd

for vm in ${VMLIST}
do
 echo backup_all_vm.sh:Backing up ${SRCDIR} ${vm}
 ./backup_vm.sh "${SRCDIR}" ${vm}
done
done