FROM nesslinger/docker-alpine-java

MAINTAINER bwnyasse

ARG version
# ARG proxy
#
# ENV http_proxy ${proxy}
# ENV https_proxy ${proxy}

#==================================================================================
#==================================================================================
# ============ Fluentd SETUP
#==================================================================================
#==================================================================================

# ============== Inspiring from Official  : https://github.com/fluent/fluentd-docker-image/blob/master/Dockerfile

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apk delete build*' has no effect
RUN apk --no-cache --update add \
                            build-base \
                            ca-certificates \
                            ruby \
                            ruby-irb \
                            ruby-dev && \
    echo 'gem: --no-document' >> /etc/gemrc && \
    gem install oj && \
    gem install fluentd -v 0.12.28 && \
    apk del build-base ruby-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/lib/ruby/gems/*/cache/*.gem


# for log storage (maybe shared with host)
RUN mkdir -p /fluentd/log && \

    # configuration/plugins path (default: copied from .)
    mkdir -p /fluentd/etc /fluentd/plugins


# Tell ruby to install packages as user
RUN echo "gem: --user-install --no-document" >> ~/.gemrc
ENV PATH /root/.gem/ruby/2.3.0/bin:$PATH
ENV GEM_PATH /root/.gem/ruby/2.3.0:$GEM_PATH

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

# ============ start - fluent configuration
# Install fluent plugins
RUN gem install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-parser && \
    gem install fluent-plugin-concat && \
    gem install fluent-plugin-record-reformer && \
    gem install fluent-plugin-better-timestamp && \
    gem install fluent-plugin-color-stripper

ADD fluentd/manage /fluentd/etc/

COPY fluentd/fluent.conf /fluentd/etc/
# ============ end - fluent configuration

EXPOSE 24224 5140

#==================================================================================
#==================================================================================
# ============ ElasticSearch SETUP
#==================================================================================
#==================================================================================

# ============== Inspiring from https://github.com/joschi/docker-alpine-elasticsearch/blob/master/Dockerfile


ENV ELASTICSEARCH_MAJOR 2.3
ENV ELASTICSEARCH_VERSION 2.3.5
ENV ELASTICSEARCH_URL_BASE https://download.elasticsearch.org/elasticsearch/elasticsearch
ENV PATH /opt/elasticsearch/bin:$PATH


RUN set -ex \
	&& apk --update add bash curl \
	&& rm -rf /var/cache/apk/*
RUN curl -fsSL -o /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64 \
	&& chmod 0755 /usr/bin/dumb-init
RUN set -x \
	&& curl -fsSL -o /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.3/gosu-amd64 \
	&& chmod +x /usr/local/bin/gosu
RUN set -ex \
	&& mkdir -p /opt \
	&& curl -fsSL -o /tmp/elasticsearch.tar.gz $ELASTICSEARCH_URL_BASE/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
	&& tar -xzf /tmp/elasticsearch.tar.gz -C /opt \
	&& rm -f /tmp/elasticsearch.tar.gz \
	&& mv /opt/elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch \
	&& for path in \
		/opt/elasticsearch/data \
		/opt/elasticsearch/logs \
		/opt/elasticsearch/config \
		/opt/elasticsearch/config/scripts; do mkdir -p "$path"; done
	# && addgroup elasticsearch \
	# && adduser -D -G elasticsearch -h /opt/elasticsearch elasticsearch \

COPY es/config /opt/elasticsearch/config

VOLUME /opt/elasticsearch/data

EXPOSE 9200 9300

#==================================================================================
#==================================================================================
# ============ ElasticSearch DUMP SETUP
#==================================================================================
#==================================================================================
RUN apk add --update nodejs \
    && rm -rf /var/cache/apk/* \
    && npm install --global --production --no-optional elasticdump@$ELASTICSEARCH_DUMP_VERSION

#==================================================================================
#==================================================================================
# ============ ElasticSearch Curator SETUP
#==================================================================================
#==================================================================================
RUN apk add --update nodejs \
  && apk add py-pip \
  && pip install elasticsearch-curator==3.5.1

COPY ./es/curator.sh /
RUN sed -i 's/\r$//' /curator.sh && chmod +x /curator.sh

#==================================================================================
#==================================================================================
# ============ lighttpd SETUP
#==================================================================================
#==================================================================================
# RUN apk add --update \
#     lighttpd \
#   && rm -rf /var/cache/apk/*
#
# RUN adduser www-data -G www-data -H -s /bin/false -D
#
# USER led
# ADD www /var/www/
# USER root
#
# RUN chown -R led:led /var/www/
#
# COPY lighttpd/lighttpd.conf /etc/lighttpd/
#
# EXPOSE 8080

#==================================================================================
#==================================================================================
# ============ NGINX SETUP
#==================================================================================
#==================================================================================
# Install nginx
RUN apk add --update nginx && \
    rm -rf /var/cache/apk/* && \
    adduser www-data -G www-data -H -s /bin/false -D && \
    chown -R www-data:www-data /var/lib/nginx

ADD www /var/www/

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/includes/ /etc/nginx/includes/
COPY nginx/404.html /var/www/

# Expose the ports for nginx
EXPOSE 8080 443

#==================================================================================
#==================================================================================
# ============ LED customization Service SETUP
#==================================================================================
#==================================================================================

ENV ES_SERVER_HOST_ADDRESS localhost
ENV ES_PORT 9200
ENV ES_INDEX fluentd
ENV APP_VERSION ${version}
ENV ES_CURATOR_DAY_OLDER_THAN 7
ENV ES_CURATOR_SCHEDULE 00 00 * * *

#== Install HEAD plugin
RUN /opt/elasticsearch/bin/plugin install mobz/elasticsearch-head
ENTRYPOINT [
# ============ start - custom sh
COPY ./env.sh /
COPY ./infos.sh /
COPY ./logger.sh /
COPY ./healthcheck.sh /
COPY ./start.sh /

RUN sed -i 's/\r$//' /env.sh && chmod +x /env.sh \
 && sed -i 's/\r$//' /infos.sh && chmod +x /infos.sh \
 && sed -i 's/\r$//' /logger.sh && chmod +x /logger.sh \
 && sed -i 's/\r$//' /healthcheck.sh && chmod +x /healthcheck.sh \
 && sed -i 's/\r$//' /start.sh && chmod +x /start.sh
# =========== end - custom sh

# ============= Server Config Directory
ADD server/conf /opt/led/conf/
ADD server/target/*swarm.jar /opt/led/app.jar

VOLUME /opt/led/conf/

ENTRYPOINT ["/start.sh" ]
CMD [""]
