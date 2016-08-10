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
    templateUrl: 'packages/fluentd_log_explorer/components/container_log_cmp.html',
    useShadowDom: false)
class ContainerLogCmp extends ShadowRootAware {
  ElasticSearchService service;
  String container_id;

  ContainerLogCmp(this.service);

  getMessage(source) => quiver_strings.isNotEmpty(source['message']) ? source['message'] : source['log'];

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

  getSelectedAlertLevelCss() {
    String css = "";
    if (service.hasCurrentLogLevel()) {
      String level = service.currentLogLevel.toUpperCase();
      if (level != null) {
        if (level.contains('INFO')) {
          return 'alert-info';
        } else if (level.contains('WARN')) {
          return 'alert-warning';
        } else if (level.contains('ERR')) {
          return 'alert-danger';
        }
      }
    }

    return css;
  }

  getLevelCss(source) => _effectiveGetLevelCss(getLevel(source));

  _effectiveGetLevelCss(level) {
    String css = 'label-default';
    if (level != null) {
      if (level.contains('INFO')) {
        return 'label-info';
      } else if (level.contains('WARN')) {
        return 'label-warning';
      } else if (level.contains('ERR')) {
        return 'label-danger';
      }
    }
    return css;
  }

  getTime(source) {
    String time = source['@timestamp'];
    DateTime dateTime = DateTime.parse(time);
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
    var strictDate = new DateFormat('HH:mm:ss,ms');
    return strictDate.format(date).toString();
  }

  getOutput(source) => (source['source']);

  getContainerNameAndId(source) => source['container_name'] + " id:" + source['container_id'];

  getHisto() {
    if (quiver_strings.isNotEmpty(service.currentHisto)) {
      DateTime dateTime = DateTime.parse(service.currentHisto);
      DateTime date = new DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
      var strictDate = new DateFormat('HH:mm:ss');
      return "Since " + strictDate.format(date).toString();
    }
  }

  launchFilter() {
    handler(null);
  }

  @override
  void onShadowRoot(ShadowRoot shadowRoot) {
    querySelector('#filter-input-id')
      ..onChange.listen(handler)
      ..onKeyDown.listen(handler)
      ..onKeyUp.listen(handler)
      ..onCut.listen(handler)
      ..onPaste.listen(handler);

    // TODO: implement onShadowRoot
  }

  handler(event) => service.getLogsByContainerName(service.currentContainerName,
      level: service.currentLogLevel, histo: service.currentHisto, filter: service.currentFilterValue);
}
