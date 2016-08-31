#!/bin/bash
#
# @description
# Push to docker hub
#
# @author bwnyasse
##

docker login -u=$DOCKER_USERNAME -p=$DOCKER_PASSWORD
docker push ${DOCKER_REPOSITORY}:latest
docker tag  ${DOCKER_REPOSITORY}:${VERSION}
docker push  ${DOCKER_REPOSITORY}:${VERSION}
