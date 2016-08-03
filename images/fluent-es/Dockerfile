FROM fluent/fluentd:latest
MAINTAINER bwnyasse
#USER ubuntu
#WORKDIR /home/ubuntu
#ENV PATH /home/ubuntu/ruby/bin:$PATH

#ARG proxy
#
#ENV http_proxy ${proxy}
#ENV https_proxy ${proxy}
#ENV no_proxy=.mipih.net,.mipih.fr,localhost,127.0.0.1

RUN gem install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-parser
COPY fluentd.conf /fluentd/etc/
EXPOSE 24284
CMD exec fluentd -c /fluentd/etc/fluentd.conf -p /fluentd/plugins $FLUENTD_OPT
