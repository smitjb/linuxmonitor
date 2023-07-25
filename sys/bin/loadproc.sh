#set -x
if [ $# -lt 3 ];then

echo "usage: loadproc.sh connect_string procedure_name owner"
exit 1
fi
echo PACKAGE ${2} ${3}
sqlplus -s ${1} <<EOF
set timing off
set define off
alter session set current_schema=${3};
@${2}.prc
EOF
