#!/bin/bash
#
# @description
# Push to docker hub
#
# @author bwnyasse
##
set -e

docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
docker tag -f ${DOCKER_REPOSITORY}:${VERSION} ${DOCKER_REPOSITORY}:latest
docker push ${DOCKER_REPOSITORY}:${VERSION}
