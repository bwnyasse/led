[![Build Status](https://travis-ci.org/bwnyasse/led.svg?branch=master)](https://travis-ci.org/bwnyasse/led)
[![GitHub Tags](https://img.shields.io/github/tag/bwnyasse/led.svg)](https://github.com/bwnyasse/led)

# Logs Explorer for Docker aka  **[LED](https://hub.docker.com/r/bwnyasse/fluentd-led/)**

## Purpose

The goal is to provide an easy process for exploring and visualizing container logs.

LED wants to keep everything as simple as possible. **But it is in very early stage**

The following picture shows you a quick look of a running LED instance.

![](doc/current_v0.4.png?raw=true)

LED is designed for microservice architecture builds with [docker](https://www.docker.com/).

If you are already familiar with [elastic stack](https://www.elastic.co/fr/webinars/introduction-elk-stack),
LED **understanding** will be very easy for you.

### Logging Driver

LED assumes that you are using [docker logging driver](https://docs.docker.com/engine/admin/logging/fluentd/) to send container logs to the [Fluentd](http://www.fluentd.org/) collector as structured log data.


## How to use it ?

#### 1- Launch container

LED requires the following ports to be published:

 - **8080** : used by the hosted web server to serves led
 - **24224**: default port used by fluentd for TCP forwarding

<pre>
 docker run -d -p 8080:8080 -p 24224:24224 bwnyasse/led:0.5.0
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
          bwnyasse/led:0.5.0

Connecting a mysql database as follow :

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        --name=mysql_db \
        -e MYSQL_ROOT_PASSWORD=my-secret-pw \
        --log-driver=fluentd \
        --log-opt tag="default.docker.{{.Name}}" \
        mysql

##  Customize your running instance of LED

##### - Using Environment variables

| Name                |        Description                  | Default Value             |
| --------------------|-------------------------------------|---------------------------|
| APP_NAME            |  Customize application name         |                           |
| APP_CONTEXT_URL     |  Define application context url. For example if you are running under a reverse proxy, we must give the right app url (host:port)   |                           |
| ES_CURATOR_SCHEDULE |  Schedule [curation](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/about.html) of old elastic indices         | 00 00 \* \* \* ( midnight)|

**Example:**

Assuming LED , that we have the following requirements:
- Wolverine as Application Name
- LED will run under a reverse proxy and will be available to MY_HOST:MY_PORT
- We want to trigger elastic search curation every 5 minutes

<pre>
    docker run -d \
          -v /etc/localtime:/etc/localtime:ro \
          -v /etc/timezone:/etc/timezone:ro \
          -p 8080:8080 \
          -p 24224:24224 \
          -e APP_NAME=Wolverine \
          -e APP_CONTEXT_URL=MY_HOST:MY_PORT \
          -e ES_CURATOR_SCHEDULE=*/5 * * * * 
          bwnyasse/led:0.5.0
</pre>

##### - Level color

Use the settings page, to modify the level color. The following picture give you a quick look of current available level Configuration

![](doc/settings_1.png?raw=true)

##  Manage Tag option

**Sometimes , it is more better to filter logs by level. At this stage of project, LED display log level only with the default log format of the following services** :

  - Jboss Wildfly & Wildfly Swarm
  - MongoDB

The following table show you fluent tag requires by LED to match service and if the log level is displayed or not


| Service     |    Log Tag                    |  Display Log Level |
| ------------|-------------------------------|--------------------|
| wildfly     |    wildfly.docker.{{.Name }}  |      true          |
| MongoDB     |    mongo.docker.{{.Name }}    |      true          |
|   *         |    default.docker.{{.Name }}  |      false         |   

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


## More to come ... ( see [issues](https://github.com/bwnyasse/led/issues) ) :
