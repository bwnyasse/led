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

///
///
@Injectable()
class LRouter implements Function {

  static const String DEFAULT_VIEW_PATH = 'views/';

  ///
  /// Logs
  ///
  static const String DEFAULT_VIEW_LOGS = 'logs';
  static const String DEFAULT_VIEW_LOGS_PATH = 'views/logs/';
  static const String DEFAULT_VIEW_LOGS_HTML = DEFAULT_VIEW_LOGS_PATH + 'logs.html';

  ///
  /// Config
  ///
  static const String DEFAULT_VIEW_CONFIG = 'config';
  static const String DEFAULT_VIEW_CONFIG_PATH = 'views/config/';
  static const String DEFAULT_VIEW_CONFIG_HTML = DEFAULT_VIEW_CONFIG_PATH + 'config.html';

  call(Router router, RouteViewFactory viewFactory) {
    viewFactory.configure({
      DEFAULT_VIEW_LOGS: ngRoute(
          defaultRoute: true,
          path: '/' + DEFAULT_VIEW_LOGS, view: DEFAULT_VIEW_LOGS_HTML, enter: onLogsRouteEnter),
      DEFAULT_VIEW_CONFIG: ngRoute(
          path: '/' + DEFAULT_VIEW_CONFIG, view: DEFAULT_VIEW_CONFIG_HTML, enter: onConfigRouteEnter)
    });
  }


  onLogsRouteEnter(RouteEnterEvent event) {}
  onConfigRouteEnter(RouteEnterEvent event) {}
}