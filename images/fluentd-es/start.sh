#!/bin/sh

echo "Starting ... "

/bin/sh /env.sh > /var/www/js/env.js

cat  /var/www/js/env.js

lighttpd -f /etc/lighttpd/lighttpd.conf && \
fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
