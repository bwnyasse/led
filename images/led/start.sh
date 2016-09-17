#!/bin/sh
#===================================================================================================#
#title           :start.sh
#description     :This script is used as entry point for the container
#author		       :bwnyasse
#==================================================================================================#
set -e

echo "Starting ... "

#== Generate the.js file from the GUI
/bin/sh /env.sh > /var/www/js/env.js
/bin/sh /infos.sh > /var/www/js/infos.js

#== Uncomment this line to display env to stdout
cat  /var/www/js/env.js
cat  /var/www/js/infos.js

#== Effective start: lighttpd
lighttpd -f /etc/lighttpd/lighttpd.conf

#== Effective Start Server
java -jar /home/led/server/app.jar -Dswarm.http.port=8081 &

#== Effective start: ElasticSearch
/bin/sh /opt/elasticsearch/bin/elasticsearch &

  #== Effective start: fluentd
  fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
