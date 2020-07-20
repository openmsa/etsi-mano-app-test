#!/bin/bash
#
# Validate syntax and keywords existance in each Robot file

res=0
for i in */*/*.robot ; do
	[[ "$i" != *"Keywords.robot"* && "$i" != *"Keyword.robot"* ]] && \
	(echo "++++ Dryrun $i" && \
	robot --dryrun --output NONE --report NONE --log NONE $i || \
	(echo "++++ Issues in file $i" && res=1));
done

exit $res
