set -x
for x in OLINT10 OLINT11 OLINT12
do
tnsping $x
if [ "$?" == "0" ]
then
sqlplus system/planta1n@${x} <<EOF
begin
 dbms_defer_sys.unregister_propagator('repadmin');
end;
/
drop user repadmin cascade;
drop user repdemo cascade;
exit
EOF
else
 echo "$x not accessible"
fi
done

