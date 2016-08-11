#!/bin/sh
#===================================================================================================#
#title           :env.sh
#description     :This script will generate a file used by the GUI to retrieve env var at runtime
#author		       :bwnyasse
#==================================================================================================#

echo "env = {"
echo "  ES_BROWSER_HOST: '$ES_BROWSER_HOST',"
echo "  ES_PORT: '$ES_PORT',"
echo "  ES_INDEX: '$ES_INDEX'"
echo "}"
