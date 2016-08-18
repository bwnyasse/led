import 'package:quiver/strings.dart' as quiver_strings;

class Utils {

  // Level contains Label
  static String LABEL_ERROR = "ERR";
  static String LABEL_WARNING = "WAR";
  static String LABEL_INFO = "INFO";
  static String LABEL_DEBUG = "DEBUG";
  static String LABEL_TRACE = "TRACE";
  static String LABEL_FATAL = "FATAL";

  // Regex
  static RegExp LOG_FORMAT_REGEXP_WILDFLY = new RegExp(
      r"^(^.*m)?( +)?(\d{4}-\d{2}-\d{2})?( +)?(\d{1,2}:\d{1,2}:\d{1,2},\d{1,3}) ([^\s]+) (.*)");
  static RegExp LOG_FORMAT_REGEXP_MONGO = new RegExp(
      r"^(\d{4}-\d{2}-\d{2})T?( +)?(\d{1,2}:\d{1,2}:\d{1,2}.\d{1,3})\+(\d{0,4})?( +)?(I|E|F|D|W)( +)?(.*)");

  // container Type
  static String CONTAINER_TYPE_WILDFLY = "wildfly";
  static String CONTAINER_TYPE_MONGO = "mongo";

  static Map retryFormatWildfly({String log}) {
    Map json = new Map();

    // Test the fomat
    json.addAll(retryFormat(log: log, regExp: LOG_FORMAT_REGEXP_WILDFLY));

    // Check if always empty , check if contains started by any JAVA error
    if (json.isEmpty &&
        (log.contains("Caused by:") || log.contains("Exception in"))) {
      json['level'] = "ERROR";
      json['message'] = log;
    }

    return json;
  }

  static Map retryFormatMongo({String log}) {
    Map json = new Map();

    // Test the fomat
    json.addAll(retryFormat(log: log, regExp: LOG_FORMAT_REGEXP_MONGO));

    return json;
  }

  static Map retryFormat({String log, RegExp regExp}) {
    Map json = new Map();
    var matches = regExp.allMatches(log);
    if (matches.isNotEmpty) {
      Match match = matches.elementAt(0);
      if (match.groupCount == 7) {
        json['time_forward'] = match[5].trim();
        json['level'] = match[6].trim();
        json['message'] = match[7].trim();
      }
    }

    return json;
  }

  static getLevelFormat(var type, String inputLevel) {
    if (quiver_strings.equalsIgnoreCase(type, CONTAINER_TYPE_MONGO) &&
        inputLevel != null) {
      inputLevel = inputLevel.toUpperCase();

      switch (inputLevel) {
        case 'I':
          return 'INFO';
        case 'E':
          return 'ERROR';
        case 'W':
          return 'WARNING';
        case 'D':
          return 'DEBUG';
        case 'F':
          return 'FATAL';
      }
    }

    return inputLevel;
  }
}
