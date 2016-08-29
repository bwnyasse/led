#!/bin/bash
#
# @description
# Script used to launch integration
#
# @author bwnyasse
##

FLAG_M=false
FLAG_S=false

usage() {
	cat <<-EOF

  Script used to launch integration

	OPTIONS:
	========
  -s, --skip-build      skip build for required project
  -m, --maven-build     launch maven build for required project
  -h                    show this help

	EOF
}

function launchCompose {
  docker-compose -f led.yml up --build --force-recreate --remove-orphans -d && \
  docker-compose -f service.yml up --build --force-recreate -d
}

#################
### Read options
################
while true; do
    case "$1" in
        -m | --maven-build)
          FLAG_M=true
          break ;;
        -s | --skip-build)
          FLAG_S=true
          break ;;
        *|-h)
            usage
            exit 1 ;;
    esac
done

if $FLAG_M; then
  mvn clean install -f ./javaee/wildfly-swarm/ && \
  launchCompose
elif $FLAG_S; then
  launchCompose
fi
