
while :
do
sqlplus /nolog <<EOF
connect $1
@$2
exit
EOF
sleep $3
done