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

part of fluentd_log_explorer;

@Injectable()
class LConfiguration {

  // Default Manage Level contains Label
  static String LABEL_ERROR = "ERROR";
  static String LABEL_WARNING = "WARN";
  static String LABEL_INFO = "INFO";
  static String LABEL_DEBUG = "DEBUG";
  static String LABEL_TRACE = "TRACE";
  static String LABEL_FATAL = "FATAL";


  List getLogTagFormat() {
    List logTagFormat = [];
    logTagFormat.add(new LogTagFormat(service:"Wildfly / Wildfly Swarm",tag:"wildfly.docker.{{.Name }}",format:Utils.LOG_FORMAT_REGEXP_WILDFLY.pattern));
    logTagFormat.add(new LogTagFormat(service:"MongoDB",tag:"mongo.docker.{{.Name }}",format:Utils.LOG_FORMAT_REGEXP_MONGO.pattern));
    logTagFormat.add(new LogTagFormat(service:"*",tag:"default.docker.{{.Name }}",format:Utils.LOG_FORMAT_REGEXP_DEFAULT.pattern));
    return logTagFormat;
  }

  List getLevelsLogMessageConfiguration() {
    List levelsConfiguration = [];
    levelsConfiguration.add(new LevelConfiguration(
        name: 'ERROR', pattern: LABEL_ERROR, color: '#D9534F'));
    levelsConfiguration.add(new LevelConfiguration(
        name: 'WARNING', pattern: LABEL_WARNING, color: '#F0AD4E'));
    levelsConfiguration.add(new LevelConfiguration(
        name: 'FATAL', pattern: LABEL_FATAL, color: '#973A37'));
    return levelsConfiguration;
  }

  List getLevelsConfiguration() {
    List levelsConfiguration = [];
    levelsConfiguration.add(new LevelConfiguration(
        name: 'ERROR', pattern: LABEL_ERROR, color: '#D9534F'));
    levelsConfiguration.add(new LevelConfiguration(
        name: 'WARNING', pattern: LABEL_WARNING, color: '#F0AD4E'));
    levelsConfiguration.add(new LevelConfiguration(
        name: 'INFO', pattern: LABEL_INFO, color: '#5BC0DE'));
    levelsConfiguration.add(new LevelConfiguration(
        name: 'DEBUG', pattern: LABEL_DEBUG, color: '#6DD4C0'));
    levelsConfiguration.add(new LevelConfiguration(
        name: 'TRACE', pattern: LABEL_TRACE, color: '#FAE6C9'));
    levelsConfiguration.add(new LevelConfiguration(
        name: 'FATAL', pattern: LABEL_FATAL, color: '#973A37'));
    return levelsConfiguration;
  }

  String getCssLevelLogMessage(String level){
    LevelConfiguration levelConfiguration = getLevelsLogMessageConfiguration().firstWhere((config) => level.contains(config.pattern));
    return _getInlineCssLevelLogMessage(levelConfiguration.color);
  }

  String getCssLevelLabel(String level){
    LevelConfiguration levelConfiguration = getLevelsConfiguration().firstWhere((config) => level.contains(config.pattern));
    return _getInlineCssLevelLabel(levelConfiguration.color);
  }

  String getCssLevelMenu(String level){
    LevelConfiguration levelConfiguration = getLevelsConfiguration().firstWhere((config) => level.contains(config.pattern));
    return _getInlineCssLevelMenu(levelConfiguration.color);
  }

  _getInlineCssLevelMenu(String color) => '''
    border-left: 7px solid $color;
    text-transform: uppercase;
  ''';

  _getInlineCssLevelLabel(String color) => '''
     background-color: $color;
  ''';

  _getInlineCssLevelLogMessage(String color) => '''
    color: $color;
    font-weight: bold;
    border: 1px solid;
  ''';

}

class LevelConfiguration {
  String name;
  String pattern;
  String color;

  LevelConfiguration({this.name, this.pattern, this.color});

  toString() => " $name - $pattern - $color";
}

class LogTagFormat {
  String service;
  String tag;
  String format;

  LogTagFormat({this.service, this.tag, this.format});
}