#!/bin/sh
#===================================================================================================#
#title           :start.sh
#description     :This script is used as entry point for the container
#author		       :bwnyasse
#==================================================================================================#

source logger.sh
source cron_curator_routine.sh

set -e

inf "Starting LED... "

#== Generate the.js file from the GUI
/bin/sh /env.sh > /var/www/js/env.js
/bin/sh /infos.sh > /var/www/js/infos.js

#== Uncomment this line to display env to stdout
cat  /var/www/js/env.js
cat  /var/www/js/infos.js

#== Install Cron for elastic Curator ( run it every day at midnight )
install_cron 

#== Effective start: nginx
/bin/sh -c nginx -g daemon off;

#== Effective start: lighttpd
#lighttpd -f /etc/lighttpd/lighttpd.conf

#== Effective Start Server
java -jar /opt/led/app.jar -Dswarm.bind.address=127.0.0.1 -Dswarm.http.port=7777 &

#== Effective start: ElasticSearch
/bin/sh /opt/elasticsearch/bin/elasticsearch -Des.insecure.allow.root=true &

/bin/sh /healthcheck.sh  &

  #== Effective start: fluentd
  fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
