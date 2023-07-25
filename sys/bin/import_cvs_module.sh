MODULE="${1}"

if [ -d /u/code ];then
    pushd /u/code
elif [ -d /var/code ];then
    pushd /var/code
elif [ -d /cygdrive/t ];then
    pushd /cygdrive/t
else
    echo "Unknown directory structure"
    exit 1
fi
    

if [ -z ${MODULE} ]; then
    echo "No parameter supplied"
    exit 1
fi

if [ ! -d ${MODULE} ];then
    echo "No such module:[${MODULE}]"
    exit 1
fi

if [ -d ${MODULE}/CVS  ];then
    echo "module [${MODULE}] is already in CVS"
    exit 2
fi

pushd ${MODULE}
cvs import -m"First import" ${MODULE} FIRST IMPORT
popd

mv ${MODULE} ${MODULE}.preimport
cvs checkout ${MODULE}

popd


