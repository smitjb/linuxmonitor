#set -x
if [ $# -lt 3 ];then

echo "usage: dumppkg.sh connect_string package_name owner"
exit 1
fi
echo PACKAGE ${2} ${3}
sqlplus -s ${1} <<EOF
set timing off
@dumppkg ${2} ${3}
EOF
topandtail.sh ${2}.pkg
topandtail.sh ${2}.pkb