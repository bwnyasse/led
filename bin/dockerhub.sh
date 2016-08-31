#!/bin/bash
#
# @description
# Push to docker hub
#
# @author bwnyasse
##
#set -e

echo "here"
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
docker push ${DOCKER_REPOSITORY}
docker tag  ${DOCKER_REPOSITORY}:${VERSION}
docker push  ${DOCKER_REPOSITORY}:${VERSION}
