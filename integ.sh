#!/bin/bash
#
# @description
# Script used to launch integration
#
# @author bwnyasse
##

CURRENT=$(pwd)
INTEGRATION_PATH=$CURRENT/integ

cd $INTEGRATION_PATH && ./launch.sh
