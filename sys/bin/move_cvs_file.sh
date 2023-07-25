

SOURCE=$1
TARGET=$2
FILE=$3

if [ -z "${SOURCE}" ] ;then
    echo "No source"
    exit 1
fi

if [ -z "${TARGET}" ] ;then
    echo "No target"
    exit 1
fi

if [ -z "${FILE}" ] ;then
    echo "No file"
    exit 1
fi

if [ -d /u/code ];then
    CODEROOT=/u/code
elif [ -d /var/code ];then
    CODEROOT=/var/code
elif [ -d /cygdrive/t ];then
    CODEROOT=/cygdrive/t
else
    echo "Unknown directory structure"
    exit 1
fi

pushd ${CODEROOT} >/dev/null

if [  ! -d ${SOURCE} ]; then
    echo Invalid source [${SOURCE} 
    exit 2
fi

if [  ! -d ${TARGET} ]; then
    echo Invalid target [${TARGET} ]
    exit 2
fi

if [ ! -f ${SOURCE}/${FILE} ];then
    echo Invalid source file [${SOURCE}/${FILE} ]
    exit 2
    
fi

if [  -f ${TARGET}/${FILE} ];then
    echo Target file already exists [${TARGET}/${FILE} ]
    exit 2
    
fi

# Update the file in the source sandbox

pushd ${SOURCE}  >/dev/null
cvs update ${FILE}
popd  >/dev/null


# move the file to the target sandbox

pushd ${SOURCE}  >/dev/null 
cp ${FILE} ${FILE}.migrated_to_${TARGET}
mv ${FILE} ../${TARGET}/${FILE}
popd  >/dev/null

# remove the file from the source repository

pushd ${SOURCE}  >/dev/null
cvs remove ${FILE}
cvs commit -m"Migrated to ${TARGET}" ${FILE}
popd  >/dev/null

# add the file to the target repository

pushd ${TARGET}  >/dev/null
cvs add ${FILE}
cvs commit -m"Migrated from ${SOURCE}"  ${FILE}
popd  >/dev/null

popd  >/dev/null
