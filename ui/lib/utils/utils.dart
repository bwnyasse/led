class Utils {
  static RegExp LOG_FORMAT_REGEXP_WILDFLY = new RegExp(r"^(.*m)(\d{1,2}:\d{1,2}:\d{1,2},\d{1,3}) ([^\s]+) (.*)");

  static Map retryFormatWildfly({String log}) {
    Map json = new Map();

    // Test the fomat
    json.addAll(retryFormat(log: log, regExp: LOG_FORMAT_REGEXP_WILDFLY));

    // Check if always empty , check if contains started by any JAVA error
    if(json.isEmpty && (log.startsWith("Caused by:") || log.startsWith("Exception in"))){
      json['level'] = "ERROR";
      json['suffix'] = "";
      json['message'] = log;
    }

    return json;
  }

  static Map retryFormat({String log, RegExp regExp}) {
    Map json = new Map();
    var matches = regExp.allMatches(log);
    if(matches.isNotEmpty){
      Match match = matches.elementAt(0);
      if (match.groupCount == 4) {
        json['suffix'] = match[1].trim();
        json['time'] = match[2].trim();
        json['level'] = match[3].trim();
        log = log.replaceAll(match[1],"");
        log = log.replaceAll(match[2],"");
        log = log.replaceAll(match[3],"");
        json['message'] =log;
      }
    }

    return json;
  }
}
