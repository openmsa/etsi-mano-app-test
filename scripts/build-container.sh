#!/bin/bash
# Copyright ETSI 2019
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

#set -e
set -vx

DOCKER_FILE=./scripts/docker/Dockerfile
if [ -f ${DOCKER_FILE} ]
then
    #check and build stf583-rf-validation image
    DOCKER_ID=`docker ps -a | grep -e stf583-rf-validation | awk '{ print $1 }'`
#    if [ ! -z "${DOCKER_ID}" ]
#    then
#        docker rm --force stf583-rf-validation
#    fi
    docker build --tag stf583-rf-validation -f ${DOCKER_FILE} .
    if [ "$?" != "0" ]
    then
        echo "Docker build failed: $?"
        exit -1
    fi
#    docker image ls -a
#    docker inspect stf583-rf-validation:latest
#    if [ "$?" != "0" ]
#    then
#        echo "Docker inspect failed: $?"
#        exit -2
#    fi
#else
#    exit -3
fi

# That's all Floks
exit 0

