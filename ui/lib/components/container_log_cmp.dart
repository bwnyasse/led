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
class ContainerLogCmp extends ShadowRootAware {
  ElasticSearchService service;
  LConfiguration configuration;

  ContainerLogCmp(this.service,this.configuration);

  displayedContainerId() => service.currentContainerId != null
      ? 'id: ' + service.currentContainerId.substring(0, 9) + '...'
      : "";

  getMessage(Input input) =>
      quiver_strings.isNotEmpty(input.message) ? input.message : input.log;

  getMessageCss(Input input) {
    String css = '';
    String level = getLevel(input);
    if (quiver_strings.isNotEmpty(level)) {
      css = configuration.getCssLevelLogMessage(level);
    }
    return css;
  }

  getLevel(Input input) => input.level.getRenderedValue();

  getSelectedAlertLevelCss() {
    String css = "";
    if (service.hasCurrentLogLevel()) {
      String level = service.currentLogLevel.getRenderedValue().toUpperCase();
      css = _effectiveGetLevelCss(level);
      print(css);
    }

    return css;
  }

  getLevelCss(Input input) => _effectiveGetLevelCss(getLevel(input));

  _effectiveGetLevelCss(level) {
    String css = 'label-default';
    if (level != null) {
       css = configuration.getCssLevelLabel(level);
    }
    return css;
  }

  getTime(Input input) {
    // if (quiver_strings.isNotEmpty(input.time_forward)) {
    //   return input.time_forward;
    // }
    String time = input.timestamp;
    DateTime dateTime = DateTime.parse(time);
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch);
    var strictDate = new DateFormat('HH:mm:ss,ms');
    return strictDate.format(date).toString();
  }

  getOutput(Input input) => input.source;

  getContainerNameAndId(Input input) =>
      input.container_name + " id:" + input.container_id;

  getHisto() {
    if (quiver_strings.isNotEmpty(service.currentHisto)) {
      DateTime dateTime = DateTime.parse(service.currentHisto);
      DateTime date = new DateTime.fromMillisecondsSinceEpoch(
          dateTime.millisecondsSinceEpoch);
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
  }

  handler(event) => service.getLogsByContainerName(service.currentContainerName,
      level: service.currentLogLevel,
      histo: service.currentHisto,
      filter: service.currentFilterValue);

  onPageInfiniteScroll() => service.getLogsByContainerNameOnFiniteScroll();

}
