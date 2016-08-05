## MEMO TO BUILD BASIC GUI 

-list all indexes on ElasticSearch server?
    curl http://localhost:9200/_aliases?pretty=1

- Search from index 
    curl http://localhost:9200/nginx1/_search?pretty=1' 
    
- Pagination with from / size
    curl http://localhost:9200/nginx2/_search?pretty=1&size=y&from=i