echo "Checking for required patches"
for patchid in 118345 119961 117837 117846 118682
do
 echo "==============================================================="
 echo "${patchid}..."
 patchadd -p | grep ${patchid}
 echo "...${patchid} done."
 echo "==============================================================="
done
echo "Checking naming and name resolution"
cat /etc/nsswitch.conf | grep hosts:
echo "hosttname should be a FQDN"
hostname
echo "domainname should be blank"
domainname
cat /etc/hosts | grep vmsol1001
echo "Checking kernel parameters"
for kernelparm in max-sem-ids max-sem-nsems max-shm-memory max-shm-ids
do
 echo "==============================================================="
 echo "${kernelparm}..."
 prctl -n project.${kernelparm} -i project user.root
 echo "...Done"
 echo "==============================================================="
done
