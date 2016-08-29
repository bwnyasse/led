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

#############################
### Effectif Script build ###
############################
launchOption=''
if $FLAG_M; then
    launchOption='-m'
elif $FLAG_S; then
    launchOption='-s'
fi

CURRENT=$(pwd)
INTEGRATION_PATH=$CURRENT/integ

cd $INTEGRATION_PATH && ./launch.sh $launchOption
