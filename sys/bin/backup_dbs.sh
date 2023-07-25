
for host in thoth shiva
do
echo "Backing up ${host}"
#scp -r jim@${host}:/jbs/var/backup/oracle  /cygdrive/z
rsync -rtzv  --rsh="ssh -l oracle" --delete ${host}:/jbs/var/backup/oracle/ /cygdrive/z/oracle/${host}
done
