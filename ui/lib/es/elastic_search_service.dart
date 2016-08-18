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
class ElasticSearchService extends AbstractRestService {
  static String ES_URL =
      "http://" + jsinterop.ES_BROWSER_HOST + ":" + jsinterop.ES_PORT + "/";

//  static String ES_TYPE = "fluentd";
  static String SEARCH_PREFIX = "/_search?pretty=true";
  static String UPDATE_PARTIAL_PREFIX = "/_update";
  static String MAPPING_PREFIX = "/_mapping";
  static String INDEX_URL = ES_URL + "_aliases?pretty=1";
  static String SEARCH_URL = ES_URL + "_search";
  static String INDEX_PREFIX ="fluentd-";

  String currentIndex;
  String currentContainerName;
  String currentContainerId;
  Level currentLogLevel;
  String currentHisto;
  String currentFilterValue;

  List<String> indexes = [];
  List<String> containers = [];
  List<Level> levels = [];
  List<String> dateHisto = [];

  Set<Input> sourceLogsByContainerName = new Set();

  ElasticSearchService() {
    _pingES();
    _getIndexes();
  }

  _pingES() {
    String url = ES_URL + "?hello=elasticsearch";
    _head(url).then((response) {
      jsinterop.showNotieSuccess('ElasticSearch is available at : $ES_URL');
    }).catchError((error) {
      jsinterop
          .showNotieError('[ERROR] ElasticSearch is unreachable at $ES_URL');
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
    String url = '$ES_URL$index/fluentd$MAPPING_PREFIX';
    _post(url,
        sendData: JSON.encode(ElasticSearchQueryDSL._dslEnsureLogAnalyzed()));
  }

  getContainersForCurrentIndex() async {
    getContainersByIndex(currentIndex);
  }

  getContainersByIndex(String index) async {
    currentIndex = index;

    containers.clear();
    String url = "$ES_URL$currentIndex$SEARCH_PREFIX";
    Map dsl = ElasticSearchQueryDSL._dslAvailableContainers();
    _post(url, sendData: JSON.encode(dsl)).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      List buckets = jsonResponse['aggregations']
          [ElasticSearchQueryDSL.ES_AGG_CONTAINER_NAME]['buckets'];
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
      {Level level: null, String histo: null, String filter: null}) async {
    currentContainerName = containerName;
    currentLogLevel = level;
    currentHisto = histo;
    currentFilterValue = filter;
    String url = "$ES_URL$currentIndex$SEARCH_PREFIX";
    Map dsl =
        ElasticSearchQueryDSL._dslLogs(containerName, level, histo, filter);

    sourceLogsByContainerName.clear();

    _post(url, sendData: JSON.encode(dsl)).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      List listHists = jsonResponse['hits']['hits'];
      List inputList = [];
      listHists.forEach((hists) {
        Input input = new Input.fromJSON(hists);
        currentContainerId = input.container_id;
        inputList.add(retryFormat(input));
      });
      sourceLogsByContainerName.addAll(inputList);

      // update level
      levels.clear();
      List b1 = jsonResponse['aggregations']
          [ElasticSearchQueryDSL.ES_AGG_LOG_LEVEL]['buckets'];
      b1.forEach((json) {
        levels.add(new Level(
            value: json['key'],
            displayedValue: Utils.getLevelFormat(
                listHists[0]['_source']['container_type'], json['key'])));
      });

      // Update date histo
      dateHisto.clear();
      List b2 = jsonResponse['aggregations']
          [ElasticSearchQueryDSL.ES_AGG_DATE_HISTOGRAM_AGGREGATION]['buckets'];
      b2.forEach((json) {
        // Add only 4 ( means last hour )
        if (dateHisto.length < 4) {
          if (json['doc_count'] != 0) {
            dateHisto.add(json['key_as_string']);
          }
        }
      });
    });
  }

  retryUpdateLogFormat(
      {String type,
      String id,
      String time_forward,
      String level,
      String message}) {
    String url = "$ES_URL$currentIndex/$type/$id$UPDATE_PARTIAL_PREFIX";
    String json = ElasticSearchQueryDSL._dslRetryUpdateLogFormat(
        time_forward: time_forward, level: level, message: message);
    print(json);
    _post(url, sendData: JSON.encode(json));
  }

  clearFilterValue() {
    currentFilterValue = null;
    getLogsByContainerName(currentContainerName,
        level: currentLogLevel,
        histo: currentHisto,
        filter: currentFilterValue);
  }

  clearLogLevel() {
    currentLogLevel = null;
    getLogsByContainerName(currentContainerName,
        level: currentLogLevel,
        histo: currentHisto,
        filter: currentFilterValue);
  }

  clearLogHisto() {
    currentHisto = null;
    getLogsByContainerName(currentContainerName,
        level: currentLogLevel,
        histo: currentHisto,
        filter: currentFilterValue);
  }

  hasCurrentLogLevel() =>
      currentLogLevel != null &&
      quiver_strings.isNotEmpty(currentLogLevel.value);

  hasCurrentLogHisto() => quiver_strings.isNotEmpty(currentHisto);

  hasCurrentContainerName() =>
      quiver_strings.isNotEmpty(currentContainerName) &&
      quiver_strings.isNotEmpty(currentContainerId);

  hasCurrentFilterValue() => quiver_strings.isNotEmpty(currentFilterValue);

  retryFormat(Input input) {
    if (quiver_strings.isNotEmpty(input.message)) {
      return input;
    }

    Map json = new Map();

    //WILDFLY
    if (quiver_strings.equalsIgnoreCase(
        input.container_type, Utils.CONTAINER_TYPE_WILDFLY)) {
      json.addAll(Utils.retryFormatWildfly(log: input.log));
    }

    if (json.isNotEmpty) {
      // Update Input
      input.time_forward = json['time_forward'];
      input.level = json['level'];
      input.message = json['message'];
      // Update to ES
      retryUpdateLogFormat(
          type: input.type,
          id: input.id,
          time_forward: input.time_forward,
          level: input.level.value,
          message: input.message);
    }

    return input;
  }
}
