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
  ContainerService containerService;
  String container_id;

  ContainerLogCmp(this.service,this.containerService);

  getMessage(Input input) {
    String toDisplay = "";
    if (quiver_strings.isNotEmpty(input.message)) {
      toDisplay = input.message;
    } else {
      toDisplay = input.log;

      // Try to retry the formatting
      containerService.retryFormat(input);
    }
    return toDisplay;
  }

  getMessageCss(Input input) {
    String css = '';
    String level = getLevel(input);
    if (level != null) {
      if (level.contains('WARN')) {
        return 'log-warning';
      } else if (level.contains('ERR')) {
        return 'log-error';
      }
    }
    return css;
  }

  getLevel(Input input) => input.level;

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

  getLevelCss(Input input) => _effectiveGetLevelCss(getLevel(input));

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

  getTime(Input input) {
    String time = input.timestamp;
    DateTime dateTime = DateTime.parse(time);
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
    var strictDate = new DateFormat('HH:mm:ss,ms');
    return strictDate.format(date).toString();
  }

  getOutput(Input input) => input.source;

  getContainerNameAndId(Input input) => input.container_name + " id:" + input.container_id;

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
