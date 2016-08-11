#!/bin/sh
#===================================================================================================#
#title           :start.sh
#description     :This script is used as entry point for the container
#author		       :bwnyasse
#==================================================================================================#

echo "Starting ... "

#== Generate the env.js for env var management from the GUI
/bin/sh /env.sh > /var/www/js/env.js

#== Uncomment this line to display env to stdout
#cat  /var/www/js/env.js

#== Effective start: lighttpd + fluentd
lighttpd -f /etc/lighttpd/lighttpd.conf && \
fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
