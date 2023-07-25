
dir=x$$

rm -rf $dir
mkdir $dir
cd $dir

scp -r ${1}@${2}:${3} .

echo Code is in $(pwd)

