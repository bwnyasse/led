#!/bin/sh
#===================================================================================================#
#title           :env.sh
#description     :This script will generate a file used by the GUI to retrieve env var at runtime
#author		       :bwnyasse
#==================================================================================================#
echo "env = {"
echo "  APP_NAME: '$APP_NAME',"
echo "  APP_CONTEXT_URL: '$APP_CONTEXT_URL',"
echo "  ES_SERVER_HOST_ADDRESS: '$ES_SERVER_HOST_ADDRESS',"
echo "  ES_PORT: '$ES_PORT'"
echo "}"
