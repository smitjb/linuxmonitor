if [ $# -lt 3 ];then

echo "usage: dumpproc.sh connect_string package_name owner"
exit 1
fi

. db_cc_functions.sh
#echo PROCEDURE ${2}
#sqlplus -s ${1} <<EOF
#set timing off
#@dumpproc ${2}
#EOF

dumpproc ${1} ${2} ${3}
topandtail  ${2}.prc