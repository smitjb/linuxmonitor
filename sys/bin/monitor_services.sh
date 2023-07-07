for host in $(cat monitor_services.ini | awk -F: '{ print $1 }')
do
	echo -n "$host ->"
	ping -c 1 $host >/dev/null
	if [ $? == 0 ];then
		echo "  pingable"
	else
		echo "  not pingable"
	fi
	for port in $(grep $host monitor_services.ini | awk -F: '{ print $2 }')
	do
		nc -z  -4 ${host} ${port} #>/dev/null #2&>1
		if [ $? == 0 ];then
			echo OK ${host} ${port} open
		else
			echo FAIL ${host} ${port} not open
		fi
	done
done


