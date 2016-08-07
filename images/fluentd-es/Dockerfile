FROM fluent/fluentd:latest
MAINTAINER bwnyasse

RUN gem install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-parser && \
    gem install fluent-plugin-concat && \
    gem install fluent-plugin-record-reformer

COPY fluent.conf /fluentd/etc/
EXPOSE 24284

CMD exec fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
