/**
 * Copyright (c) 2016 ui. All rights reserved
 *
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 *
 * DO NOT ALTER OR REMOVE THIS HEADER.
 *
 * Created on : 16/09/16
 * Author     : bwnyasse
 *
 */

part of led_ui;

@Injectable()
class LConfiguration extends AbstractRestService {


  static String CONFIG_REST_URL = AbstractRestService.CONTEXT_URL +"/server/_api/configuration";

  // Default Manage Level contains Label
  static String LABEL_ERROR = "ERROR";
  static String LABEL_WARNING = "WARN";
  static String LABEL_INFO = "INFO";
  static String LABEL_DEBUG = "DEBUG";
  static String LABEL_TRACE = "TRACE";
  static String LABEL_FATAL = "FATAL";

  List logTagFormat = [];
  List levelsLogMessageConfiguration = [];
  List nodesConfiguration = [];
  List levelsConfiguration = [];

  LConfiguration(){
    loadConfig();
    //
    logTagFormat.add(new LogTagFormat(service:"Wildfly / Wildfly Swarm",tag:"wildfly.docker.{{.Name }}",format:Utils.LOG_FORMAT_REGEXP_WILDFLY.pattern));
    logTagFormat.add(new LogTagFormat(service:"MongoDB",tag:"mongo.docker.{{.Name }}",format:Utils.LOG_FORMAT_REGEXP_MONGO.pattern));
    logTagFormat.add(new LogTagFormat(service:"*",tag:"default.docker.{{.Name }}",format:Utils.LOG_FORMAT_REGEXP_DEFAULT.pattern));

  }

  loadConfig() async {
    _get(CONFIG_REST_URL).then((response) {
      _updateConfig(response.responseText);
    });
  }

  saveConfig(List nodes, List levels) async {
    Map json = new Map();

    List nodesToSave = [];
    nodes.forEach((node) =>nodesToSave.add(node.toJson()));
    json['nodes'] = nodesToSave;

    List levelsToSave = [];
    levels.forEach((level) =>levelsToSave.add(level.toJson()));
    json['levels'] = levelsToSave;

    _post(CONFIG_REST_URL,sendData: JSON.encode(json)).then((response) {
      _updateConfig(response.responseText);
    });
  }

  _updateConfig(var responseText) async {
    levelsLogMessageConfiguration.clear();
    levelsConfiguration.clear();
    nodesConfiguration.clear();

    Map jsonResponse = JSON.decode(responseText);
    // Node
    List nodes= jsonResponse['nodes'];
    nodes.forEach((json) {
      NodeConfiguration node = new NodeConfiguration.fromJson(json);
      nodesConfiguration.add(node);
    });

    // Level
    List levels= jsonResponse['levels'];
    levels.forEach((json) {
      LevelConfiguration level = new LevelConfiguration.fromJson(json);
      levelsConfiguration.add(level);
      if(level.loggify){
        levelsLogMessageConfiguration.add(level);
      }
    });

    jsinterop.initJSC();
  }

  List getLogTagFormat() => logTagFormat;

  List getLevelsLogMessageConfiguration() => levelsLogMessageConfiguration;

  List getLevelsConfiguration() =>  levelsConfiguration;

  List getNodesConfiguration() =>  nodesConfiguration;

  Map getCssLevelLogMessage(String level){
    List where = getLevelsLogMessageConfiguration().where((config) => level.contains(config.pattern));
    if(where.isNotEmpty){
      LevelConfiguration levelConfiguration = where.elementAt(0);
      return levelConfiguration!=null ? _getInlineCssLevelLogMessage(levelConfiguration.color) : "";
    }
    return {};

  }

  Map getCssLevelLabel(String level){
    List where = getLevelsConfiguration().where((config) => level.contains(config.pattern));
    if(where.isNotEmpty){
      LevelConfiguration levelConfiguration =  where.elementAt(0);
      return  levelConfiguration!=null ?  _getInlineCssLevelLabel(levelConfiguration.color): "";
    }
    return {};

  }

  Map getCssLevelMenu(String level){
    List where = getLevelsConfiguration().where((config) => level.contains(config.pattern));
    if(where.isNotEmpty){
      LevelConfiguration levelConfiguration =  where.elementAt(0);
      return  levelConfiguration!=null ?  _getInlineCssLevelMenu(levelConfiguration.color): "";
    }
    return {};
  }


  _getInlineCssLevelMenu(String color) => {
    'border-left': '7px solid $color',
    'text-transform': 'uppercase'
  };

  _getInlineCssLevelLabel(String color) => {
    'background-color': '$color'
  };

  _getInlineCssLevelLogMessage(String color) => {
    'color': '$color',
    'font-weight': 'bold',
    'border': '1px solid'
  };

}

class LevelConfiguration {
  String name;
  String pattern;
  String color;
  bool loggify;

  LevelConfiguration({this.name, this.pattern, this.color});
  LevelConfiguration.fromJson(Map json):
      this.name= json['name'],
      this.pattern= json['pattern'],
      this.color= json['color'],
      this.loggify= json['loggify'] == 'true';


  toJson() {
    Map json = new Map();
    json['name']= name;
    json['pattern']= pattern;
    String sanitizeColor = color.replaceAll("#","");
    json['color']= "#" + sanitizeColor;
    json['loggify'] = loggify.toString();
    return json;
  }

  toString() => " $name - $pattern - $color - $loggify";
}

class NodeConfiguration {
  String id;
  String name;
  String host;
  String port;

  NodeConfiguration.empty():
        this.id = new uuid.Uuid().v1().toString(),
        this.name = '',
        this.host = '',
        this.port = '';

  NodeConfiguration.fromJson(Map json):
        this.id = new uuid.Uuid().v1().toString(),
        this.name= json['name'],
        this.host= json['host'],
        this.port= json['port'].toString();

  toJson() {
    Map json = new Map();
    json['name']= name;
    json['host']= host;
    json['port']= port;
    return json;
  }

  isValid() => name.isNotEmpty && host.isNotEmpty && port.isNotEmpty;

  toString() => " $name - $host:$port ";
}

class LogTagFormat {
  String service;
  String tag;
  String format;

  LogTagFormat({this.service, this.tag, this.format});
}
