#!/bin/sh

echo "yeah"


#env
unset http_proxy && \
unset https_proxy && \
unset no_proxy && \
fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
