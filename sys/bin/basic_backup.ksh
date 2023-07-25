
SRCDIR=${1}
DESTDIR=${2}

STG2DIR=/cygdrive/z/$(hostname)
SRCFILE=$(basename ${SRCDIR})
SUFFIX=$(date +%Y%m%d%H%M%S )

DESTFILE=${DESTDIR}/${SRCFILE}_${SUFFIX}.tgz


echo Backing up ${SRCDIR} to ${DESTFILE} and then to ${STG2DIR}

tar czvf ${DESTFILE} ${SRCDIR} >/dev/null


FINDNAME=${SRCFILE}\*

if [ ! -d ${STG2DIR} ] ;then
 echo Creating ${STG2DIR}
 mkdir ${STG2DIR}
fi

mv ${DESTFILE} ${STG2DIR}
pushd ${STG2DIR} >/dev/null
echo The following files are being deleted
find ${STG2DIR}  -name ${SRCFILE}\* -mtime +3 -a -type f -print -exec rm {} \;    
popd >/dev/null
pushd ${DESTDIR} >/dev/null
echo The following files are being deleted
find ${DESTDIR}  -name ${SRCFILE}\* -a -mtime +3 -a -type f -print -exec rm {} \;
popd >/dev/null