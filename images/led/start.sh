#!/bin/sh
#===================================================================================================#
#title           :start.sh
#description     :This script is used as entry point for the container
#author		       :bwnyasse
#==================================================================================================#

source logger.sh

set -e

inf "Starting LED... "

#== Generate the.js file from the GUI
/bin/sh /env.sh > /var/www/js/env.js
/bin/sh /infos.sh > /var/www/js/infos.js

#== Uncomment this line to display env to stdout
cat  /var/www/js/env.js
cat  /var/www/js/infos.js

#== Install Cron for elastic Curator ( run it every day at midnight )
LOGFIFO='/var/log/cron.fifo'
if [[ ! -e "$LOGFIFO" ]]; then
    mkfifo "$LOGFIFO"
fi
echo -e "00 00 * * * /curator.sh > $LOGFIFO 2>&1" | crontab -
crond

#== Effective start: nginx
/bin/sh -c nginx -g daemon off;

#== Effective start: lighttpd
#lighttpd -f /etc/lighttpd/lighttpd.conf

#== Effective Start Server
java -jar /opt/led/app.jar -Dswarm.bind.address=127.0.0.1 -Dswarm.http.port=7777 &

#== Effective start: ElasticSearch
/bin/sh /opt/elasticsearch/bin/elasticsearch -Des.insecure.allow.root=true &

  #== Effective start: fluentd
  fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
