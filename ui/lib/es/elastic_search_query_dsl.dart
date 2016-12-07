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
part of led_ui;

class ElasticSearchQueryDSL {

  static int DEFAULT_MAX_FETCH_LOGS_SIZE = 50;

  static String INTERVAL_DATE_HISTOGRAM_AGGREGATION = "15m";

  // ES field
  static String ES_FIELD_TIMESTAMP = "@timestamp";
  static String ES_FIELD_TIME_NANO = "time_nano";
  static String ES_FIELD_CONTAINER_NAME = "container_name";
  static String ES_FIELD_LOG_LEVEL = "level";
  static String ES_FIELD_LOG_TIME_FORWARD = "time_forward";
  static String ES_FIELD_LOG_MESSAGE = "message";
  static String ES_FIELD_LOG_LOG = "log";
  static String ES_FIELD_LOG_SUFFIX = "suffix";

  // ES Aggre
  static String ES_AGG_LOG_LEVEL = "agg_log_level";
  static String ES_AGG_CONTAINER_NAME = "agg_container_name";
  static String ES_AGG_DATE_HISTOGRAM_AGGREGATION =
      "agg_date_histo_aggregation";

  ///
  /// DSL
  ///
  static _dslAvailableContainers() => {
        "size": "0",
        "aggs": {
          ES_AGG_CONTAINER_NAME: {
            "terms": {"field": ES_FIELD_CONTAINER_NAME}
          }
        }
      };

  static _dslLogs(String containerName, Level level, String histo,
          String filterValue,int from) =>
      {
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
        "from": from,
        "size": DEFAULT_MAX_FETCH_LOGS_SIZE,
        "sort": {ES_FIELD_TIME_NANO: "desc"},
        "aggs": _dslCommonAggregation()
      };

  static _dslLogLevel(Level level) =>
      level == null || quiver_strings.isEmpty(level.value)
          ? {}
          : {
              "term": {ES_FIELD_LOG_LEVEL: level.value}
            };

  static _dslLogHisto(String histo) => quiver_strings.isEmpty(histo)
      ? {}
      : {
          "range": {
            ES_FIELD_TIMESTAMP: {
              "gte": DateTime.parse(histo).millisecondsSinceEpoch,
              "lte": new DateTime.now().millisecondsSinceEpoch
            }
          }
        };

  static _dslLogFilterValue(String filterValue) =>
      quiver_strings.isEmpty(filterValue)
          ? {}
          : {
              "wildcard": {
                ES_FIELD_LOG_LOG: "*" + filterValue.toLowerCase() + "*"
              }
            };

  static _dslCommonAggregation() => {
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

  static _dslEnsureLogAnalyzed() => {
        "properties": {
          "log": {"type": "string", "index": "analyzed"}
        }
      };

  static _dslRetryUpdateLogFormat(
          {String time_forward, String level, String message}) =>
      {
        "doc": {
          ES_FIELD_LOG_TIME_FORWARD: time_forward,
          ES_FIELD_LOG_LEVEL: level,
          ES_FIELD_LOG_MESSAGE: message
        }
      };
}
