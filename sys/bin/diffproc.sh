
. db_cc_functions.sh

DIFFCMD="/cygdrive/c/Program Files/WinMerge/WinMergeU.exe"


pushd ${TMP} >/dev/null
dumpproc ${1} ${2} ${3}
popd 

echo "${DIFFCMD}" $(cygwin2dos ${TMP})\\${2}.prc ${2}.prc
"${DIFFCMD}" $(cygwin2dos ${TMP})\\${2}.prc ${2}.prc

pushd ${TMP} >/dev/null
rm $2.prc
exit


