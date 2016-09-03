[![Build Status](https://travis-ci.org/bwnyasse/fluentd-led.svg?branch=master)](https://travis-ci.org/bwnyasse/fluentd-led)

# Fluentd - Log Explorer for Docker aka  **[LED](https://hub.docker.com/r/bwnyasse/fluentd-led/)**

## Purpose

The goal is to provide an easy process for exploring and visualizing container logs.

LED wants to keep everything as simple as possible. But it is in very early stage.

The following picture shows you a quick look of a running LED instance.

![](current_5.png?raw=true)

LED is designed for microservice architecture builds with [docker](https://www.docker.com/).

If you are already familiar with [elastic stack](https://www.elastic.co/fr/webinars/introduction-elk-stack),
LED **setup** will be very easy for you.

### Logging Driver

LED assumes that you are using the fluentd logging driver to send container logs to the Fluentd collector as structured log data.


## How to use it ?

### Basic ( on localhost )

#### 1- Launch container

LED requires the following ports to be published:
 - **8080**: used for the hosted web server that serves led ui
 - **24224**: default port by fluentd for TCP forwarding
 - **9200**: used by internal instance of elasticsearch


    docker run -d -p 8080:8080 -p 24224:24224 -p 9200:9200 bwnyasse/fluentd-led


*Navigate to localhost:8080 to see a basic running instance of LED.*

#### 2- Add container logs

The following command will connect a wildfly container to LED

    docker run -d \
        --name=wildfly_server \
        --log-driver=fluentd \
        --log-opt tag="wildfly.docker.{{.Name}}" \
        jboss/wildfly:10.0.0.Final

*Navigate to localhost:8080 to see your container logs in LED*

**That's it !!**

## Important : Setting the Timezone in a Docker image

Time in your running container may be out of sync with your host and can cause you troubles when exploring your logs.  
To avoid this behavoir , one of the good pratices is to read-only mount your host /etc/timezone and /etc/localtime in your container.

Launching led as follow :

    docker run -d \
          -v /etc/localtime:/etc/localtime:ro \
          -v /etc/timezone:/etc/timezone:ro \
          -p 8080:8080 \
          -p 24224:24224 \
          -p 9200:9200 \
          bwnyasse/fluentd-led

Connecting wildlfy as follow :

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        --name=wildfly_server_sync \
        --log-driver=fluentd \
        --log-opt tag="wildfly.docker.{{.Name}}" \
        jboss/wildfly:10.0.0.Final

## Current State ( v0.2.0)

**At this stage of project, LED works only with the default log format of the following service** :

  - Jboss Wildfly & Wildfly Swarm
  - MongoDB

The following table displayed fluent tag requires by LED to match service with logs

      | Service       |            Fluentd Tag                  |
      | ------------- |-----------------------------------------|
      | wildfly       |        wildfly.docker.{{.Name }}        |
      | MongoDB       |        mongo.docker.{{.Name }}          |

For example, the following command will connect a wildfly container to LED

        docker run -d \
            -v /etc/localtime:/etc/localtime:ro \
            -v /etc/timezone:/etc/timezone:ro \
            --name=mongo_db \
            --log-driver=fluentd \
            --log-opt tag="mongo.docker.{{.Name}}" \
            mongo:3.2.8

## More to come ... ( see [issues](https://github.com/bwnyasse/fluentd-led/issues) ) :
- Better wiki & documentation :
  - how to connect external elasticsearch instance
  - log storage strategy
- Add another services and make LED more generic. Actually, only Wildfly & MongoDB are well implemented in LED.
