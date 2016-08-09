FROM elasticsearch:2.3.5

MAINTAINER bwnyasse

# Mount elasticsearch.yml config
COPY config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

# Install HEAD plugin
RUN /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
