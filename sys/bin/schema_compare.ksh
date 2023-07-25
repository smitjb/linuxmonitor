user1=${1}
passwd1=${2}
db1=${3}
user2=${4}
passwd2=${5}
db2=${6}
schema1=${7}
schema2=${8}


echo "Extracting db structure"

sqlplus -s ${user1}/${passwd1}@${db1} @DUMPALLTABLES ${schema1} ${db1}
sqlplus -s ${user1}/${passwd1}@${db1} @DUMPALLINDEXES ${schema1} ${db1}
sqlplus -s ${user1}/${passwd1}@${db1} @DUMPALLVIEWS ${schema1} ${db1}
sqlplus -s ${user1}/${passwd1}@${db1} @DUMPALLSOURCE ${schema1} ${db1}
sqlplus -s ${user2}/${passwd2}@${db2} @DUMPALLTABLES ${schema2} ${db2}
sqlplus -s ${user2}/${passwd2}@${db2} @DUMPALLINDEXES ${schema2} ${db2}
sqlplus -s ${user2}/${passwd2}@${db2} @DUMPALLVIEWS ${schema2} ${db2}
sqlplus -s ${user2}/${passwd2}@${db2} @DUMPALLSOURCE ${schema2} ${db2}

echo Comparing tables
diff ${db1}_${schema1}_tables.lst ${db2}_${schema2}_tables.lst >/dev/null
if [ ! "$?" == "0" ]
then
 echo Differences in tables 
fi
echo Comparing indexes
diff ${db1}_${schema1}_indexes.lst ${db2}_${schema2}_indexes.lst >/dev/null
if [ ! "$?" == "0" ]
then
 echo Differences in indexes 
fi
echo Comparing views
diff ${db1}_${schema1}_views.lst ${db2}_${schema2}_views.lst >/dev/null
if [ ! "$?" == "0" ]
then
 echo Differences in views
fi
echo Comparing source
diff ${db1}_${schema1}_source.lst ${db2}_${schema2}_source.lst >/dev/null
if [ ! "$?" == "0" ]
then
 echo Differences in source
fi

