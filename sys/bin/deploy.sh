
#
# Deploy the utilities directory to all hosts
#
#

SYNCEDHOSTS=$(cat /cygdrive/c/progs/utils/etc/synchosts|dos2unix|sort)
KNOWNHOSTS=$(cat ~/.ssh/known_hosts|sort|cut -d" " -f1|cut -d, -f1)
#KNOWNHOSTS="dldba01 oat1db-l"

TARGETHOSTS=${KNOWNHOSTS}
for HOST in ${SYNCEDHOSTS}
do
# echo "=======================Removing ${HOST} using using sed s/${HOST}// "
  TARGETHOSTS=$(echo ${TARGETHOSTS} | sed s/${HOST}//)
# echo "[[[[[[[[[[[[[${TARGETHOSTS}]]]]]]]]]]] after"
# TARGETHOSTS=${TARGETHOSTS2}
done
for HOST in ${TARGETHOSTS}
 do  
    echo ${HOST} 
    scp -r ~/deploy/* smi425@${HOST}:~
#    scp ~/deploy/.profile smi425@${HOST}:~
    echo ${HOST} >>/cygdrive/c/progs/utils/etc/synchosts 
 done
