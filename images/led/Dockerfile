FROM fluent/fluentd:latest

MAINTAINER bwnyasse

USER root

# ============ start - fluent configuration
# Install fluent plugins
RUN gem install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-parser && \
    gem install fluent-plugin-concat && \
    gem install fluent-plugin-record-reformer && \
    gem install fluent-plugin-better-timestamp && \
    gem install fluent-plugin-color-stripper

COPY manage/wildfly.conf /fluentd/etc/
COPY manage/mongo.conf /fluentd/etc/

COPY fluent.conf /fluentd/etc/
# ============ end - fluent configuration


# ============ start - lighttpd configuration
# Install lighttpd web server
RUN apk add --update \
    lighttpd \
  && rm -rf /var/cache/apk/*

RUN adduser www-data -G www-data -H -s /bin/false -D

ADD www /var/www/

COPY lighttpd/lighttpd.conf /etc/lighttpd/
# ============ end - lighttpd configuration



# ============ start - custom sh
COPY ./env.sh /
RUN sed -i 's/\r$//' /env.sh && chmod +x /env.sh

COPY ./start.sh /
RUN sed -i 's/\r$//' /start.sh && chmod +x /start.sh
# =========== end - custom sh

EXPOSE 24284
EXPOSE 8080

CMD ["/start.sh" ]
