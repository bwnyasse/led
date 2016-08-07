FROM fluent/fluentd:latest
MAINTAINER bwnyasse

USER root

RUN gem install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-parser && \
    gem install fluent-plugin-concat && \
    gem install fluent-plugin-record-reformer && \
    gem install fluent-plugin-better-timestamp

COPY fluent.conf /fluentd/etc/
EXPOSE 24284

CMD exec fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins $FLUENTD_OPT
