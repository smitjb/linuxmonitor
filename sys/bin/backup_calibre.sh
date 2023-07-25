
pushd /cygdrive/q/
if [ -d /cygdrive/z/library ];then 
    rsync -va /cygdrive/z/library library
else
    echo "Backup drive not mounted"
fi