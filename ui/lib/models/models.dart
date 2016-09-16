part of fluentd_log_explorer;

class Input {
  String index;
  String type;
  String id;
  String container_id;
  String container_name;
  String source;
  String log;
  String container_type;
  Level level;
  String message;
  String time_forward;
  String timestamp;

  Input.fromJSON(Map map)
      : this.index = map['_index'],
        this.type = map['_type'],
        this.id = map['_id'],
        this.container_id = map['_source']['container_id'],
        this.container_name = map['_source']['container_name'],
        this.source = map['_source']['source'],
        this.log = map['_source']['log'],
        this.container_type = map['_source']['container_type'],
        this.level = new Level(
            value: map['_source']['level'],
            displayedValue: Utils.getLevelFormat(
                map['_source']['container_type'], map['_source']['level']),
            log: map['_source']['log']),
        this.message = map['_source']['message'],
        this.time_forward = map['_source']['time_forward'],
        this.timestamp = map['_source']['@timestamp'];

  int get hashCode =>
      quiver_core.hash3(source.hashCode, log.hashCode, time_forward.hashCode);

  bool operator ==(o) =>
      o is Input &&
      quiver_strings.equalsIgnoreCase(container_id, o.container_id) &&
      quiver_strings.equalsIgnoreCase(container_name, o.container_name) &&
      quiver_strings.equalsIgnoreCase(source, o.source) &&
      quiver_strings.equalsIgnoreCase(log, o.log) &&
      quiver_strings.equalsIgnoreCase(container_type, o.container_type) &&
      quiver_strings.equalsIgnoreCase(time_forward, o.time_forward);
}

class Level {
  String displayedValue;
  String value;
  String log;
  Level({this.value, this.displayedValue,this.log});

  getRenderedValue() {
    if(quiver_strings.isEmpty(displayedValue)) {
      // TODO: Better degraded mode
      if (log.contains(LConfiguration.LABEL_INFO)) {
        return LConfiguration.LABEL_INFO;
      } else if (log.contains(LConfiguration.LABEL_WARNING)) {
        return LConfiguration.LABEL_WARNING;
      } else if (log.contains(LConfiguration.LABEL_ERROR)) {
        return LConfiguration.LABEL_ERROR;
      } else if (log.contains(LConfiguration.LABEL_FATAL)) {
        return LConfiguration.LABEL_FATAL;
      } else if (log.contains(LConfiguration.LABEL_DEBUG)) {
        return LConfiguration.LABEL_DEBUG;
      } else if (log.contains(LConfiguration.LABEL_TRACE)) {
        return LConfiguration.LABEL_TRACE;
      }
    }
    return displayedValue;
  }
}
