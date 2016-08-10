class Utils {

  static RegExp LOG_FORMAT_REGEXP_WILDFLY = new RegExp(r"^(.*m)(\d{1,2}:\d{1,2}:\d{1,2},\d{1,3}) ([^\s]+) (.*)");

  static Map retryFormatWildfly({String log}) => retryFormat(log:log,regExp:LOG_FORMAT_REGEXP_WILDFLY );

  static Map retryFormat({String log, RegExp regExp}) {
    Map json = new Map();
    var matches = regExp.allMatches(log);
    Match match = matches.elementAt(0);
    if (match.groupCount == 4) {
      json['suffix'] = match[1].trim();
      json['time'] = match[2].trim();
      json['level'] = match[3].trim();
      json['message'] = match[4];
    }
    return json;
  }
}
