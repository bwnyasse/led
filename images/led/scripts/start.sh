#!/bin/bash
#===================================================================================================#
#title           :start.sh
#description     :This script is used as entry point for the container
#author		       :bwnyasse
#==================================================================================================#

set -e

source common.sh

readonly DIR="/opt/led"
readonly SCRIPT_PATH="$DIR/.led-scripts"
readonly JS_DIR=/var/www/js
readonly CURRENT_ENV_INFOS="$DIR/.infos"
readonly SERVER_BIND_ADDRESS=127.0.0.1
readonly SERVER_PORT=7777

#                 _
# _ __ ___   __ _(_)_ __
# | '_ ` _ \ / _` | | '_ \
# | | | | | | (_| | | | | |
# |_| |_| |_|\__,_|_|_| |_|

cat << "EOF"
 _     _____ ____    _           _             _   _               _
| |   | ____|  _ \  (_)___   ___| |_ __ _ _ __| |_(_)_ __   __ _  | |
| |   |  _| | | | | | / __| / __| __/ _` | '__| __| | '_ \ / _` | | |
| |___| |___| |_| | | \__ \ \__ \ || (_| | |  | |_| | | | | (_| | |_|
|_____|_____|____/  |_|___/ |___/\__\__,_|_|   \__|_|_| |_|\__, | (_)
                                                          |___/
EOF


#== Generate the.js file from the GUI
/bin/bash $SCRIPT_PATH/env.sh > $JS_DIR/env.js
/bin/bash $SCRIPT_PATH/infos.sh > $JS_DIR/infos.js

#== Uncomment this line to display env to stdout
cat  $JS_DIR/env.js >> $CURRENT_ENV_INFOS
cat  $JS_DIR/infos.js >> $CURRENT_ENV_INFOS

#== Install Cron for elastic Curator
install_curator_cron

#== Effective start: nginx
/bin/sh -c nginx -g daemon off;

#== Effective start: lighttpd
#lighttpd -f /etc/lighttpd/lighttpd.conf

#== Effective Start Server
java -jar $DIR/app.jar -Dswarm.bind.address=$SERVER_BIND_ADDRESS -Dswarm.http.port=$SERVER_PORT &

#== Effective start: ElasticSearch
/bin/sh /opt/elasticsearch/bin/elasticsearch -Des.insecure.allow.root=true &

/bin/bash -c healthcheck.sh  &

  #== Effective start: fluentd
  fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
