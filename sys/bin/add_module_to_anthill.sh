MODULE="${1}"

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
pushd ${CODEROOT}
TEMPLATE_DIR=${CODEROOT}/cvstools/etc

if [ -z ${MODULE} ]; then
    echo "No parameter supplied"
    exit 1
fi

if [ ! -d ${MODULE} ];then
    echo "No such module:[${MODULE}]"
    exit 1
fi

if [ ! -d ${MODULE}/CVS  ];then
    echo "module [${MODULE}] is not in CVS"
    exit 2
fi

pushd ${MODULE}
echo 000001 >build_number.txt
sed -s "s/TEMPLATE/${MODULE}/g" <${TEMPLATE_DIR}/build.xml >build.xml
cvs add build.xml build_number.txt
cvs commit -m"Added for anthill" build.xml build_number.txt

popd


popd


