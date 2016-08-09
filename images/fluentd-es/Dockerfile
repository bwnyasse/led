FROM fluent/fluentd:latest
MAINTAINER bwnyasse

ARG proxy

ENV http_proxy ${proxy}
ENV https_proxy ${proxy}
ENV no_proxy=.mipih.net,.mipih.fr,localhost,127.0.0.1,0.0.0.0,elasticsearch

USER root

RUN gem install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-parser && \
    gem install fluent-plugin-concat && \
    gem install fluent-plugin-record-reformer && \
    gem install fluent-plugin-better-timestamp


COPY manage/wildfly.conf /fluentd/etc/
COPY fluent.conf /fluentd/etc/

EXPOSE 24284

# Starter
COPY ./start.sh /
RUN sed -i 's/\r$//' /start.sh && chmod +x /start.sh

CMD ["/start.sh" ]
