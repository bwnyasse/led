/**
 * Copyright (c) 2016 ui. All rights reserved
 *
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 *
 * DO NOT ALTER OR REMOVE THIS HEADER.
 *
 * Created on : 05/08/16
 * Author     : bwnyasse
 *
 */
part of fluentd_log_explorer;

@Injectable()
class ElasticSearchService {
  static String ES_HOST = "http://localhost:9200/";
  static String ES_TYPE = "fluentd";
  static String SEARCH_PREFIX = "/_search?pretty=true";
  static String INDEX_URL = ES_HOST + "_aliases?pretty=1";
  static String SEARCH_URL = ES_HOST + "_search";

  String currentIndex;
  String currentContainerName;
  String currentContainerId;

  List<String> indexes = [];
  List<String> containers = [];

  List sourceLogsByContainerName = [];

  ElasticSearchService() {
    _pingES();
    _getIndexes();
  }

  _pingES() {
    String url = ES_HOST + "?hello=elasticsearch";
    _head(url).then((response) {
      jsinterop.showNotieSuccess('ElasticSearch is available at : $ES_HOST');
    }).catchError((error) {
      jsinterop
          .showNotieError('[ERROR] ElasticSearch is unreachable at $ES_HOST');
    });
  }

  _getIndexes() async {
    indexes.clear();
    _get(INDEX_URL).then((response) {
      Map jsonResponse = JSON.decode(response.responseText);
      indexes = jsonResponse.keys.toList();

      // Init containers list
      if (indexes.isNotEmpty) {
        getContainersByIndex(indexes[0]);
      }
    });
  }

  getContainersByIndex(String index) async {
    currentIndex = index;

    containers.clear();
    String url = "$ES_HOST$currentIndex$SEARCH_PREFIX";
    Map dsl = {
      "size": "0",
      "aggs": {
        ES_TYPE: {
          "terms": {"field": "container_name"}
        }
      }
    };
    _post(url, sendData: JSON.encode(dsl)).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      List buckets = jsonResponse['aggregations'][ES_TYPE]['buckets'];
      buckets.forEach((json) {
        containers.add(json['key']);
      });
    });
  }

  getLogsByContainerName(String containerName) async {
    currentContainerName = containerName;
    String url = "$ES_HOST$currentIndex$SEARCH_PREFIX";
    Map dsl = {
      "query": {
        "bool": {
          "must": [
            {
              "term": {
                "container_name": containerName
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
    };

    sourceLogsByContainerName.clear();


    _post(url, sendData: JSON.encode(dsl)).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      List listHists = jsonResponse['hits']['hits'];
      listHists.forEach((hists) {
        var source = hists['_source'];
        currentContainerId = source['container_id'];
        sourceLogsByContainerName.add(source);
      });
    });
  }

  Future<int> hasLogLevel(String level, String containerName) async {
    Completer<int> completer = new Completer();
    String url = "$ES_HOST$currentIndex$SEARCH_PREFIX";
    Map dsl = {
      "query": {
        "bool": {
          "must": [
            {
              "term": {
                "container_name": containerName
              }
            },
            {
              "match": {
                "log": level
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
    };
    _post(url, sendData: JSON.encode(dsl)).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      int size = jsonResponse['hits']['total'];
      completer.complete(size);
    });

    return completer.future;
  }

  Future<HttpRequest> _get(String url) async =>
      _performServerCall(url, 'GET');

  Future<HttpRequest> _head(String url) async =>
      _performServerCall(url, 'HEAD');

  Future<HttpRequest> _post(String url, {var sendData}) async =>
      _performServerCall(url, 'POST', sendData: sendData);

  _performServerCall(String url, String m, {var sendData: null}) async {
    Future<HttpRequest> httpRequest;

    if (sendData == null) {
      httpRequest = HttpRequest.request(url, method: m);
    } else {
      httpRequest = HttpRequest.request(url, method: m, sendData: sendData);
    }

    _addHttpRequestCatchError(httpRequest);

    return httpRequest;
  }

  _addHttpRequestCatchError(Future<HttpRequest> httpRequest) {
    // Handle Timeout
    // TODO: Handler Timeout ? maybe something wrong to call server
    httpRequest.catchError((e) {
      jsinterop.showNotieError('[ERROR]');
    });
  }

  Map<String, String> addAcceptHeadersAsJson() =>
      {'Accept': 'application/json'};

  Map<String, String> addContentTypeHeadersAsJson() =>
      {'Content-Type': 'application/json'};
}
