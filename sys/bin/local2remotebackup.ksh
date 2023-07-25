
SRCDIR=/cygdrive/l/backups
DESTDIR=/cygdrive/z/dionysus


STG2DIR=/cygdrive/z/dionysus
SRCFILE=$(basename ${SRCDIR})
SUFFIX=$(date +%Y%m%d%H%M%S )


cd ${SRCDIR}
mkdir ${DESTDIR}/${SUFFIX}

find . | cpio -pdLmv ${DESTDIR}/${SUFFIX}

find ${SRCDIR}  -mtime +5 -a -type f -print -exec rm {} \;    
find ${DESTDIR}  -mtime +5 -a -type f -print -exec rm {} \;