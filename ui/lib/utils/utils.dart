import 'package:quiver/strings.dart' as quiver_strings;

class Utils {


  // Regex
  static RegExp LOG_FORMAT_REGEXP_WILDFLY = new RegExp(
      r"^(^.*m)?( +)?(\d{4}-\d{2}-\d{2})?( +)?(\d{1,2}:\d{1,2}:\d{1,2},\d{1,3}) ([^\s]+) ([\s\S]*)");

  static RegExp LOG_FORMAT_REGEXP_MONGO = new RegExp(
      r"^(\d{4}-\d{2}-\d{2})T?( +)?(\d{1,2}:\d{1,2}:\d{1,2}.\d{1,3})?(\+|\-)?(\d{0,4})?( +)?(I|E|F|D|W)?( +)?([\s\S]*)");

  static RegExp LOG_FORMAT_REGEXP_DEFAULT = new RegExp(
      r"^( +)?([\s\S]*)");

  // container Type
  static String CONTAINER_TYPE_WILDFLY = "wildfly";
  static String CONTAINER_TYPE_MONGO = "mongo";

  static Map retryFormatWildfly({String log}) {
    Map json = new Map();

    // Test the fomat
    Map tmp = new Map();
    var matches = LOG_FORMAT_REGEXP_WILDFLY.allMatches(log.trim());
    if (matches.isNotEmpty) {
      Match match = matches.elementAt(0);
      if (match.groupCount == 7) {
        tmp['time_forward'] = match[5].trim();
        tmp['level'] = match[6].trim();
        tmp['message'] = match[7].trim();
      }
    }

    json.addAll(tmp);

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
    Map tmp = new Map();
    var matches = LOG_FORMAT_REGEXP_MONGO.allMatches(log.trim());
    if (matches.isNotEmpty) {
      Match match = matches.elementAt(0);
      if (match.groupCount == 9) {
        tmp['time_forward'] = match[3].trim();
        tmp['level'] = match[7].trim();
        tmp['message'] = match[9].trim();
      }
    }else {
      print("BAD");
    }

    json.addAll(tmp);

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
