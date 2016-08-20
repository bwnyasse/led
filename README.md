# Fluentd - Log Explorer for Docker aka  **[LED](https://hub.docker.com/r/bwnyasse/fluentd-led/)**


## Purpose

The goal is to provide an easy process for exploring and visualizing container logs.

LED wants to keep everything as simple as possible. But it is in very early stage.

The following picture shows you a quick look of LED.

![](current_4.png?raw=true)

## How to use it ?

LED is designed for microservice architecture builds with [docker](https://www.docker.com/).

If you are already familiar with [elastic stack](https://www.elastic.co/fr/webinars/introduction-elk-stack),
LED **setup** will be very easy for you.

#### Logging Driver

LED assumes that you are using the fluentd logging driver to send container logs to the Fluentd collector as structured log data.

#### Storage

LED requires a running instance of elasticsearch that allows cross origin to store container logs. You can use this [image](https://hub.docker.com/r/bwnyasse/elasticsearch-head/)

#### Launch

1- To launch and connect LED to a running instance of elasticsearch :

<pre>
docker run \
      -v /etc/localtime:/etc/localtime:ro \
      -v /etc/timezone:/etc/timezone:ro \
      -p 8080:8080 \
      -p 24224:24224 \
      -e ES_BROWSER_HOST='your_es_host_from_browser_value' \
      -e ES_HOST='your_es_host_value' \
      -e ES_PORT='your_es_port_value' \
      bwnyasse/fluentd-led
</pre>

2- Connect your container :

**At this stage of project, LED works well with the default log format of the following service** :

  - Jboss Wildfly & Wildfly Swarm
  - MongoDB

The following table displayed fluent tag requires by LED to match service with logs

      | Service       |            Fluentd Tag                  |
      | ------------- |-----------------------------------------|
      | wildfly       |        wildfly.docker.{{.Name }}        |
      | MongoDB       |        mongo.docker.{{.Name }}          |

For example , the following command will connect a wildfly container to LED

        docker run -dit \
            --log-driver=fluentd \
            --log-opt tag="wildfly.docker.{{.Name}}" \
            jboss/wildfly:10.0.0.Final

3- Using docker-compose ( recommanded )

It is very easy to launch everything with [docker-compose](https://docs.docker.com/compose/). The following snippet of docker-compose  shows you how to setup everything for mongodb container 

    version: '2'
    services:

        #-- Storage using ES that allows CROSS origin
        elasticsearch:
          image: bwnyasse/elasticsearch-head
          container_name: elasticsearch
          ports:
            - "9200:9200"
            - "9300:9300"
          volumes:
            - /etc/localtime:/etc/localtime:ro
            - /etc/timezone:/etc/timezone:ro

        #-- Effective service for LED
        fluentd-led:
          image: bwnyasse/fluentd-led
          container_name: fluentd-led
          ports:
            - 24224:24224
            - 8080:8080
          environment:
            - ES_BROWSER_HOST=localhost
            - ES_HOST=elasticsearch
            - ES_PORT=9200
            - ES_INDEX=fluentd
          depends_on:
            - elasticsearch
          volumes:
            - /etc/localtime:/etc/localtime:ro
            - /etc/timezone:/etc/timezone:ro
            -
        #-- MongoDb Instance
        mongodb:
          image: mongo:3.2.8
          ports:
            - "27017:27017"
            - "28017:28017"
          container_name: mongodb
          logging:
            driver: fluentd
            options:
              tag: "mongo.docker.{{.Name }}"
          volumes:
            - /etc/localtime:/etc/localtime:ro


## TODO:

- LED needs feedback
- Adds another services and make LED more generic. Actually, only Wildfly & MongoDB are well implemented in LED.
