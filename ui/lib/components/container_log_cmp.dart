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

@Component(
    selector: 'container-log-cmp',
    templateUrl:
    'packages/fluentd_log_explorer/components/container_log_cmp.html',
    useShadowDom: false)
class ContainerLogCmp {
  ElasticSearchService service;

  ContainerLogCmp(this.service);

  getLogMessage(source) {
    String log = source['log'];
    List split = [];
    split = ['',log];
    if (log.contains(new RegExp('INFO'))) {
      split = log.split(new RegExp('INFO'));
    } else if (log.contains(new RegExp('WARN'))) {
      split = log.split(new RegExp('WARN'));
    } else if (log.contains(new RegExp('DEBUG'))) {
      split = log.split(new RegExp('DEBUG'));
    } else if (log.contains(new RegExp('ERROR'))) {
      split = log.split(new RegExp('ERROR'));
    }
    return split[1];
  }

  getLevelMessage(source) {
    String log = source['log'];

    if (log.contains(new RegExp('INFO'))) {
      return 'INFO';
    } else if (log.contains(new RegExp('WARN'))) {
      return 'WARN';
    } else if (log.contains(new RegExp('DEBUG'))) {
      return 'DEBUG';
    } else if (log.contains(new RegExp('ERROR'))) {
      return 'ERROR';
    }
    return '';
  }
  getTime(source) {
    var timestamp = source['@timestamp'];
    DateTime dateTime = DateTime.parse(timestamp);
    var formatter = new DateFormat('H:m:s,ms');
    return formatter.format(dateTime);
  }

  getOutput(source) => (source['source']);

  getContainerNameAndId(source) =>
      source['container_name'] + " id:" + source['container_id'];


}
