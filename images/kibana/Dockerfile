FROM kibana:latest

#ARG proxy
#
#ENV http_proxy ${proxy}
#ENV https_proxy ${proxy}
#ENV no_proxy=.mipih.net,.mipih.fr,localhost,127.0.0.1

RUN apt-get update && apt-get install -y netcat

COPY kibana.yml /opt/kibana/config/
COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

RUN kibana plugin --install elastic/sense

CMD ["/tmp/entrypoint.sh"]
