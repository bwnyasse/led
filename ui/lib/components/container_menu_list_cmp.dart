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
part of led_ui;

@Component(
    selector: 'container-menu-list-cmp',
    templateUrl: 'components/container_menu_list_cmp.html')
class ContainerMenuListCmp {

  ElasticSearchService service;
  LConfiguration configuration;

  ContainerMenuListCmp(this.service, this.configuration);


  getLevelCss(String level) {
    Map css = {};
    if (level != null) {
      level = level.toUpperCase();
      css = configuration.getCssLevelMenu(level);
    }
    return css;
  }

  getIndexAsLogHistory(String index) {
    String logDate = index.replaceAll(ElasticSearchService.INDEX_PREFIX, '');
    var strictDate = new DateFormat('yyyy.MM.dd');
    DateTime today = new DateTime.now();
    DateTime yesterday = external_date_lib.Date.yesterday(today);
    if (quiver_strings.equalsIgnoreCase(
        logDate, strictDate.format(today).toString())) {
      logDate = "Today";
    } else if (quiver_strings.equalsIgnoreCase(
        logDate, strictDate.format(yesterday))) {
      logDate = "Yesterday";
    }
    return logDate;
  }

  getLogs(String container) => service.getLogsByContainerName(container);

  getLogsByLevel(Level level) =>
      service.getLogsByContainerName(service.currentContainerName,
          level: level, histo: service.currentHisto);

  getLogsByHisto(String histo) =>
      service.getLogsByContainerName(service.currentContainerName,
          level: service.currentLogLevel, histo: histo);

  getDuration(String histo) {
    DateTime dateTime = DateTime.parse(histo);
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch);
    var strictDate = new DateFormat('HH:mm:ss');
    return "From : <b>" + strictDate.format(date).toString() + "</b>";
  }

  changeIndex() => new Future(() {
    service.getContainersForCurrentIndex();
  });
}
