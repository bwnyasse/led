#!/bin/bash
#============================================================================================================#
#title           :build_server.sh
#description     :Script used to build server widlfly swarm
#author		       :bwnyasse
#===========================================================================================================#
set -e

CURRENT_PATH=$(pwd)
SERVER_PATH=$CURRENT_PATH/images/led/server

echo 'Build Server - widlfly swarm'
cd $SERVER_PATH && mvn clean package
