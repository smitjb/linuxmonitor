
DIFFCMD="/cygdrive/c/Program Files/WinMerge/WinMergeU.exe"
function dumppkg {
echo PACKAGE ${2} ${3}
sqlplus -s ${1} <<EOF
set timing off
@dumppkg ${2} ${3}
EOF

}

function cygwin2dos {

echo ${1} | sed -e 's./.\\.g' -e 's/\\cygdrive\\\(.\)/\1:/'

}

pushd ${TMP} >/dev/null
dumppkg ${1} ${2} ${3}
popd 

echo "${DIFFCMD}" $(cygwin2dos ${TMP})\\${2}.pkb ${2}.pkb
"${DIFFCMD}" $(cygwin2dos ${TMP})\\${2}.pkb ${2}.pkb

pushd ${TMP} >/dev/null

rm $2.pk?
popd
exit


