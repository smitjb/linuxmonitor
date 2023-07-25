
DIR1=$1
DIR2=$2

DIR1SIZE=$(du -sk ${DIR1}| awk '{ print $1 }' )
DIR2SIZE=$(du -sk ${DIR2}| awk '{ print $1 }' )

echo ${DIR1} ":" ${DIR1SIZE}
echo ${DIR2} ":" ${DIR2SIZE}

typeset -i PROGRESS

PROGRESS=$DIR1SIZE/$DIR2SIZE

echo $PROGRESS
