FROM fluent/fluentd:latest

MAINTAINER bwnyasse

USER root

RUN gem install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-parser && \
    gem install fluent-plugin-concat && \
    gem install fluent-plugin-record-reformer && \
    gem install fluent-plugin-better-timestamp

RUN apk add --update \
    lighttpd \
  && rm -rf /var/cache/apk/*

RUN adduser www-data -G www-data -H -s /bin/false -D

COPY lighttpd/lighttpd.conf /etc/lighttpd/

COPY manage/wildfly.conf /fluentd/etc/

COPY fluent.conf /fluentd/etc/
ADD www /var/www/

EXPOSE 24284
EXPOSE 8080

COPY ./env.sh /
RUN sed -i 's/\r$//' /env.sh && chmod +x /env.sh

COPY ./start.sh /
RUN sed -i 's/\r$//' /start.sh && chmod +x /start.sh

CMD ["/start.sh" ]
