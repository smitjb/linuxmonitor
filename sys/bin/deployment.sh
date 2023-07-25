cd /cygdrive/c/work/deploy
rm -rf /cygdrive/c/work/deploy/*

for x in elxutilities parmsutils audit capmgmt ; do   cvs -N -d h:/cvs checkout ${x}; done
for x in elxutilities parmsutils audit capmgmt ; do cd ${x} ; cvs -N tag -F RELEASE ;cd ..; done
mkdir export 
cd export
 for x in elxutilities parmsutils audit capmgmt ; do cvs -N -d h:/cvs export -r RELEASE ${x} ; done

mkdir capmgmt/lib
cd capmgmt/disktools/classes
jar cvf ../../lib/disktools.jar .

cd ..
cp disktools.dll ../bin
cd  /cygdrive/c/work/deploy
