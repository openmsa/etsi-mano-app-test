#!/bin/bash
#
# Validate syntax and keywords existance in each Robot file

cd /home/etsi/dev/robot/ 

res=0
for i in */*/*.robot ; do
    if [[ "$i" != *"Keywords.robot"* && "$i" != *"Keyword.robot"* ]] ; then
	echo "++++ Dryrun file $i"
	msg=$(robot --dryrun --output NONE --report NONE --log NONE $i 2>&1)
	if [ $? != 0 ] ; then
	    echo "++++ Issues found in file $i"
	    echo "$msg"
            res=1
        fi
    fi
done

cd /home/etsi/dev/robot2doc/robot2doc

mkdir -p /home/etsi/dev/build

python3 create_sols.py ../../robot 'local' ../../build
res2=$?

exit $res && $res2
