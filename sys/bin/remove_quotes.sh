#
#

for filename in *
do
 echo ${filename}
 sed --in-place=.bak -e 's/"//g' ${filename}

done