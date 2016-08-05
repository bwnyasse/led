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
              "field": "container_name"
            }
          }
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
