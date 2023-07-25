if [ $# -lt 3 ];then

echo "usage: dumpview.sh connect_string view_name owner"
exit 1
fi

. db_cc_functions.sh
#echo PROCEDURE ${2}
#sqlplus -s ${1} <<EOF
#set timing off
#@dumpproc ${2}
#EOF

dumpview ${1} ${2} ${3}
