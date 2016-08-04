FROM fluent/fluentd:latest
MAINTAINER bwnyasse

RUN gem install fluent-plugin-mongo && \
    gem install fluent-plugin-parser

COPY fluentd.conf /fluentd/etc/
EXPOSE 24284
CMD exec fluentd -c /fluentd/etc/fluentd.conf -p /fluentd/plugins $FLUENTD_OPT
