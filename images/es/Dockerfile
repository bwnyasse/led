FROM ypereirareis/elasticsearch-head:latest

ARG proxy

ENV http_proxy ${proxy}
ENV https_proxy ${proxy}
ENV no_proxy=.mipih.net,.mipih.fr,localhost,127.0.0.1,0.0.0.0

MAINTAINER bwnyasse

# Mount elasticsearch.yml config
COPY config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

# Install HEAD plugin
#RUN /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
