#!/bin/bash
# Copyright ETSI 2019
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

#set -e
#set -vx

mkdir -p build

docker run -v "$(pwd)/build:/home/etsi/dev/build" stf583-rf-validation:latest "bash" \
	-c  "/home/etsi/dev/robot/scripts/validate.sh"

ret=$? 

exit $ret

