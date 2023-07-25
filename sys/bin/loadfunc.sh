#set -x
if [ $# -lt 3 ];then

echo "usage: loadfunc.sh connect_string function_name owner"
exit 1
fi
echo PACKAGE ${2} ${3}
sqlplus -s ${1} <<EOF
set timing off
set define off
alter session set current_schema=${3};
@${2}.fun
EOF
