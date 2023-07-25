INSTANCE=${1}
TABLESPACE=${2}
SIZE=${3}
FILESYSTEM=${4}

typeset -l LC_TABLESPACE

if [ "$FILESYTEM" == "" ];then
    FILESYSTEM="/u02"
fi

LC_TABLESPACE=${TABLESPACE}

echo "create tablespace ${LC_TABLESPACE}"
echo "datafile '${FILESYSTEM}/oradata/${INSTANCE}/${INSTANCE}_${LC_TABLESPACE}_01.dbf' size ${SIZE}"
echo "extent management local"
echo "uniform size 128k"
echo "segment space management auto;"
