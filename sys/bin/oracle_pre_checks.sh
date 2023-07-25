
for x in $(echo \
binutils-2.15.92.0.2-13.EL4 \
compat-db-4.1.25-9 \
compat-libstdc++-296-2.96-132.7.2 \
control-center-2.8.0-12 \
gcc-3.4.3-22.1.EL4 \
gcc-c++-3.4.3-22.1.EL44 \
glibc-2.3.4-2.9 \
glibc-common-2.3.4-2.9 \
gnome-libs-1.4.1.2.90-44.1 \
libstdc++-3.4.3-22.1 \
libstdc++-devel-3.4.3-22.1 \
make-3.80-5 \
pdksh-5.2.14-30 \
sysstat-5.0.5-1 \
xscreensaver-4.18-5.rhel4.2 \
setarch-1.6-1 | awk -F- '{ print $1 }'
)
do 
 rpm -q -a | grep $x
done