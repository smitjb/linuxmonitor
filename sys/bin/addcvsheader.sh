#
#

HEADERFILE=/cygdrive/c/var/dev/sqlheader.cvs

for filename in *
do
 echo ${filename}
 mv ${filename} xxxx
 cat ${HEADERFILE} xxxx >${filename}

done