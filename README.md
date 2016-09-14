[![Build Status](https://travis-ci.org/bwnyasse/fluentd-led.svg?branch=master)](https://travis-ci.org/bwnyasse/fluentd-led)

# Log Explorer for Docker aka  **[LED](https://hub.docker.com/r/bwnyasse/fluentd-led/)**

## Purpose

The goal is to provide an easy process for exploring and visualizing container logs.

LED wants to keep everything as simple as possible. **But it is in very early stage**

The following picture shows you a quick look of a running LED instance.

![](doc/current_5.png?raw=true)

LED is designed for microservice architecture builds with [docker](https://www.docker.com/).

If you are already familiar with [elastic stack](https://www.elastic.co/fr/webinars/introduction-elk-stack),
LED **setup** will be very easy for you.

### Logging Driver

LED assumes that you are using the [fluentd](http://www.fluentd.org/) logging driver to send container logs to the Fluentd collector as structured log data.


## How to use it ?

#### 1- Launch container

LED requires the following ports to be published:

 - **8080** : used by the hosted web server to serves led ui
 - **24224**: default port used by fluentd for TCP forwarding
 - **9200** : used by internal instance of elasticsearch

<pre>
 docker run -d -p 8080:8080 -p 24224:24224 -p 9200:9200 bwnyasse/fluentd-led:0.3.0
</pre>

*Navigate to localhost:8080 to see a basic running instance of LED.*

#### 2- Add container logs

The following command will connect the docker hello-world container to LED.  ( See the [official documentation](https://docs.docker.com/engine/admin/logging/overview/#/fluentd-options) for more infos )

    docker run -d \
        --name=hello_world_container \
        --log-driver=fluentd \
        --log-opt tag="default.docker.{{.Name}}" \
        hello-world

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
          bwnyasse/fluentd-led:0.3.0

Connecting a mysql as follow :

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        --name=mysql_db \
        -e MYSQL_ROOT_PASSWORD=my-secret-pw \
        --log-driver=fluentd \
        --log-opt tag="default.docker.{{.Name}}" \
        mysql

##  Manage Tag option

**Sometimes , it is more better to filter logs by level. At this stage of project, LED display log level only with the default log format of the following services** :

  - Jboss Wildfly & Wildfly Swarm
  - MongoDB

The following table show you fluent tag requires by LED to match service and if the log level is displayed or not


        | Service       |            Fluentd Tag                  |         Display Log Level        |
        | ------------- |-----------------------------------------|----------------------------------|
        | wildfly       |    wildfly.docker.{{.Name }}            |            true                  |
        | MongoDB       |    mongo.docker.{{.Name }}              |            true                  |
        |   *           |    default.docker.{{.Name }}            |            false                 |   

Connecting wildlfy as follow :

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        --name=wildfly_server_sync \
        --log-driver=fluentd \
        --log-opt tag="wildfly.docker.{{.Name}}" \
        jboss/wildfly:10.0.0.Final

Connecting MongoDB as follow :

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        --name=mongo_db \
        --log-driver=fluentd \
        --log-opt tag="mongo.docker.{{.Name}}" \
        mongo:3.2.8

# Quick Test !

You can test LED easily using [Docker compose](https://docs.docker.com/compose), with this docker-compose.yml file:

    version: '2'
    services:

        led:
          image: bwnyasse/fluentd-led:0.3.0
          container_name: led
          ports:
            - 24224:24224
            - 8080:8080
            - 9200:9200
          volumes:
            - /etc/localtime:/etc/localtime:ro
            - /etc/timezone:/etc/timezone:ro

        hello-world:
          image: hello-world
          container_name: hello_world
          logging:
            driver: fluentd
            options:
              tag: "default.docker.{{.Name }}"
              fluentd-address: localhost:24224
          depends_on:
            - led
          volumes:
            - /etc/localtime:/etc/localtime:ro
            - /etc/timezone:/etc/timezone:ro

        wildfly:
          image: jboss/wildfly:10.0.0.Final
          container_name: wildfly_app_server
          logging:
            driver: fluentd
            options:
              tag: "wildfly.docker.{{.Name }}"
              fluentd-address: localhost:24224
          depends_on:
            - led
          volumes:
            - /etc/localtime:/etc/localtime:ro
            - /etc/timezone:/etc/timezone:ro

        mongodb:
          image: mongo:3.2.8
          ports:
            - "27017:27017"
            - "28017:28017"
          container_name: mongo_app_db
          logging:
            driver: fluentd
            options:
              tag: "mongo.docker.{{.Name }}"
              fluentd-address: localhost:24224
          depends_on:
            - led
          volumes:
            - /etc/localtime:/etc/localtime:ro


## More to come ... ( see [issues](https://github.com/bwnyasse/fluentd-led/issues) ) :
