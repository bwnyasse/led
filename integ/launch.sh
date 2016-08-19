#!/bin/bash
#
# @description
# Script used to launch integration
#
# @author bwnyasse
##

mvn clean install -f ./javaee/wildfly-swarm/ && \
docker-compose -f led.yml up --build -d && \
docker-compose -f service.yml up --build --force-recreate -d
