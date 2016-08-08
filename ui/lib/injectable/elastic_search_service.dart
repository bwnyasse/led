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

//  static String ES_TYPE = "fluentd";
  static String SEARCH_PREFIX = "/_search?pretty=true";
  static String MAPPING_PREFIX = "/_mapping";
  static String INDEX_URL = ES_HOST + "_aliases?pretty=1";
  static String SEARCH_URL = ES_HOST + "_search";
  static String INTERVAL_DATE_HISTOGRAM_AGGREGATION = "15m";

  // 15 minutes

  // ES field
  static String ES_FIELD_TIMESTAMP = "@timestamp";
  static String ES_FIELD_CONTAINER_NAME = "container_name";
  static String ES_FIELD_LOG_LEVEL = "level";
  static String ES_FIELD_LOG_MESSAGE = "message";

  // ES Aggre
  static String ES_AGG_LOG_LEVEL = "agg_log_level";
  static String ES_AGG_CONTAINER_NAME = "agg_container_name";
  static String ES_AGG_DATE_HISTOGRAM_AGGREGATION = "agg_date_histo_aggregation";

  String currentIndex;
  String currentContainerName;
  String currentContainerId;
  String currentLogLevel;
  String currentHisto;
  String currentFilterValue;

  List<String> indexes = [];
  List<String> containers = [];
  List<String> levels = [];
  List<String> dateHisto = [];

  // timestamp key_as_string

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

      // Ensure Log analyzed for all indexes
      indexes.forEach((value) {
        ensureLogAnalyzed(value);
      });

      // Init containers list
      if (indexes.isNotEmpty) {
        getContainersByIndex(indexes[0]);
      }
    });
  }

  ensureLogAnalyzed(String index) {
    //TODO : Extract type in variable
    String url = '$ES_HOST$index/fluentd$MAPPING_PREFIX';
    _post(url, sendData: JSON.encode(_dslEnsureLogAnalyzed()));
  }

  getContainersByIndex(String index) async {
    currentIndex = index;

    containers.clear();
    String url = "$ES_HOST$currentIndex$SEARCH_PREFIX";
    Map dsl = _dslAvailableContainers();
    _post(url, sendData: JSON.encode(dsl)).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      List buckets = jsonResponse['aggregations'][ES_AGG_CONTAINER_NAME]['buckets'];
      buckets.forEach((json) {
        containers.add(json['key']);

        // Init logs list
        if (containers.isNotEmpty) {
          getLogsByContainerName(containers[0]);
        }
      });
    });
  }

  getLogsByContainerName(String containerName,
      {String level: null, String histo: null, String filter: null}) async {
    currentContainerName = containerName;
    currentLogLevel = level;
    currentHisto = histo;
    currentFilterValue = filter;
    String url = "$ES_HOST$currentIndex$SEARCH_PREFIX";
    Map dsl = _dslLogs(containerName, level, histo, filter);

    sourceLogsByContainerName.clear();

    _post(url, sendData: JSON.encode(dsl)).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      List listHists = jsonResponse['hits']['hits'];
      listHists.forEach((hists) {
        var source = hists['_source'];
        currentContainerId = source['container_id'];
        sourceLogsByContainerName.add(source);

        // update level
        levels.clear();
        List b1 = jsonResponse['aggregations'][ES_AGG_LOG_LEVEL]['buckets'];
        b1.forEach((json) {
          levels.add(json['key']);
        });

        // Update date histo
        dateHisto.clear();
        List b2 = jsonResponse['aggregations'][ES_AGG_DATE_HISTOGRAM_AGGREGATION]['buckets'];
        b2.forEach((json) {
          // Add only 4 ( means last hour )
          if (dateHisto.length < 4) {
            if (json['doc_count'] != 0) {
              dateHisto.add(json['key_as_string']);
            }
          }
        });
      });
    });
  }

  clearFilterValue() {
    currentFilterValue = null;
    getLogsByContainerName(
        currentContainerName, level: currentLogLevel,
        histo: currentHisto,
        filter: currentFilterValue);
  }

  clearLogLevel() {
    currentLogLevel = null;
    getLogsByContainerName(
        currentContainerName, level: currentLogLevel,
        histo: currentHisto,
        filter: currentFilterValue);
  }

  clearLogHisto() {
    currentHisto = null;
    getLogsByContainerName(
        currentContainerName, level: currentLogLevel,
        histo: currentHisto,
        filter: currentFilterValue);
  }

  hasCurrentLogLevel() => quiver_strings.isNotEmpty(currentLogLevel);

  hasCurrentLogHisto() => quiver_strings.isNotEmpty(currentHisto);

  hasCurrentContainerName() =>
      quiver_strings.isNotEmpty(currentContainerName) &&
          quiver_strings.isNotEmpty(currentContainerId);

  hasCurrentFilterValue() => quiver_strings.isNotEmpty(currentFilterValue);

  Future<HttpRequest> _get(String url) async => _performServerCall(url, 'GET');

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

  ///
  /// DSL
  ///
  _dslAvailableContainers() => {
    "size": "0",
    "aggs": {
      ES_AGG_CONTAINER_NAME: {
        "terms": {"field": ES_FIELD_CONTAINER_NAME}
      }
    }
  };

  _dslLogs(String containerName, String level, String histo,
      String filterValue) => {
    "query": {
      "bool": {
        "must": [
          {
            "term": {ES_FIELD_CONTAINER_NAME: containerName},
            "wildcard": _dslLogFilterValue(filterValue)
          },
          _dslLogLevel(level),
          _dslLogHisto(histo)
        ],
        "must_not": [],
        "should": []
      },
    },
    "from": 0,
    "size": 5000,
    "sort": {ES_FIELD_TIMESTAMP: "desc"},
    "aggs": _dslCommonAggregation()
  };


  _dslLogLevel(String level) => quiver_strings.isEmpty(level) ?
  {} :
  {
    "term": {ES_FIELD_LOG_LEVEL: level}
  };

  _dslLogHisto(String histo) => quiver_strings.isEmpty(histo) ?
  {} :
  {
    "range":
    {
      ES_FIELD_TIMESTAMP:
      {
        "gte": DateTime
            .parse(histo)
            .millisecondsSinceEpoch,
        "lte": new DateTime.now().millisecondsSinceEpoch
      }
    }
  };

  _dslLogFilterValue(String filterValue) =>
      quiver_strings.isEmpty(filterValue) ?
      {} :
      {
        "wildcard": {
          ES_FIELD_LOG_MESSAGE: filterValue+"*"
        }
      };

  _dslCommonAggregation() => {
    ES_AGG_LOG_LEVEL: {
      "terms": {"field": ES_FIELD_LOG_LEVEL}
    },
    ES_AGG_DATE_HISTOGRAM_AGGREGATION: {
      "date_histogram": {
        "field": ES_FIELD_TIMESTAMP,
        "interval": INTERVAL_DATE_HISTOGRAM_AGGREGATION
      }
    }
  };

  _dslEnsureLogAnalyzed() => {
    "properties": {
      "log": {
        "type": "string",
        "index": "analyzed"
      }
    }
  };
}
