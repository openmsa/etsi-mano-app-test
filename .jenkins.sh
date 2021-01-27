#!/bin/bash
# Copyright ETSI 2018
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

#set -vx
#set -e

cd "$(dirname "$0")"

run_dir="$(pwd)"

bash ./scripts/build-container.sh
bash ./scripts/run-container.sh "${run_dir}"

ret=$?
echo "Final validation result: $ret"
exit $ret
