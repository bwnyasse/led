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

  getMessage(source) => quiver_strings.isNotEmpty(source['message'])
      ? source['message']
      : source['log'];

  getMessageCss(source) {
    String css = '';
    String level = getLevel(source);
    if (level != null) {
      if (level.contains('WARN')) {
        return 'log-warning';
      } else if (level.contains('ERR')) {
        return 'log-error';
      }
    }
    return css;
  }

  getLevel(source) => source['level'];

  getLevelCss(source) {
    String css = 'label-default';
    String level = getLevel(source);
    if (level != null) {
      if (level.contains('INFO')) {
        return 'label-info';
      } else if (level.contains('WARN')) {
        return 'label-warning';
      } else if (level.contains('ERR')) {
        return 'label-error';
      }
    }
    return css;
  }

  getTime(source) {
    String time = source['@timestamp'];
    DateTime dateTime = DateTime.parse(time);
    var formatter = new DateFormat('H:m:s,ms');
    return formatter.format(dateTime);
  }

  getOutput(source) => (source['source']);

  getContainerNameAndId(source) =>
      source['container_name'] + " id:" + source['container_id'];


}
