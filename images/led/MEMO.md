#wildlfy SWARM
  format /^(^.*m)?(\d{4}-\d{2}-\d{2})? (?<time>\d{1,2}:\d{1,2}:\d{1,2},\d{1,3}) (?<level>[^\s]+) (?<message>.*)/

## Online format regex checker
http://fluentular.herokuapp.com/

## MEMO TO BUILD BASIC GUI

- list all indexes on ElasticSearch server?

      curl http://localhost:9200/_aliases?pretty=1

- Search from index

      curl http://localhost:9200/nginx1/_search?pretty=1'

- Pagination with from / size

      curl http://localhost:9200/nginx2/_search?pretty=1&size=y&from=i

- distinct value of container_name in ES

  POST:
      {
        "size": 0,
        "aggs": {
          "fluentd": {
            "terms": {
              "field": "container_name"docker run -d \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    --name=mysql_sync \
    -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    --log-driver=fluentd \
    --log-opt tag="default.docker.{{.Name}}" \
    mysql:5.6

docker run -d \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    --name=wildfly_server_default_sync \
    --log-driver=fluentd \
    --log-opt tag="default.docker.{{.Name}}" \
    jboss/wildfly:10.0.0.Final

docker run -d \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    --name=wildfly_server_formatted_sync \
    --log-driver=fluentd \
    --log-opt tag="wildfly.docker.{{.Name}}" \
    jboss/wildfly:10.0.0.Final
        }
      }

- Query value and sort by timestamp

  POST:
      {
        "query": {
          "bool": {
            "must": [
              {
                "term": {
                  "container_name": "wildfly"
                }
              }
            ],
            "must_not": [],
            "should": []
          }
        },
        "from": 0,
        "size": 5000,
        "sort": {
          "@timestamp": "asc"
        },
        "aggs": {}
      }

 -  Update partial document
   URL : http://host:port/index/type/id/_update

   {
     "doc" : {
       "field": "newValue"
     }
    }

## Create containers

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        --name=mysql_sync \
        -e MYSQL_ROOT_PASSWORD=my-secret-pw \
        --log-driver=fluentd \
        --log-opt tag="default.docker.{{.Name}}" \
        mysql:5.6

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        --name=wildfly_server_default_sync \
        --log-driver=fluentd \
        --log-opt tag="default.docker.{{.Name}}" \
        jboss/wildfly:10.0.0.Final

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        --name=wildfly_server_formatted_sync \
        --log-driver=fluentd \
        --log-opt tag="wildfly.docker.{{.Name}}" \
        jboss/wildfly:10.0.0.Final

## Copy Index
for i in {10..22}
do
  elasticdump \
    --input=http://localhost:9200/fluentd-2016.09.23 \
    --output=http://localhost:9200/fluentd-2016.09.$i \
    --type=data
done
