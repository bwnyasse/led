/**
 * Copyright (c) 2016 ui. All rights reserved
 *
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 *
 * DO NOT ALTER OR REMOVE THIS HEADER.
 *
 * Created on : 07/12/16
 * Author     : bwnyasse
 *
 */

library led_ui;


import 'dart:async';
import 'dart:html';
import 'dart:js' as js;
import 'dart:convert';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';

import 'package:intl/intl.dart';
import 'utils/js_interop.dart' as jsinterop;
import 'package:quiver/strings.dart' as quiver_strings;
import 'package:quiver/collection.dart' as quiver_collection;
import 'package:quiver/core.dart' as quiver_core;
import 'package:date/date.dart' as external_date_lib;

import 'utils/utils.dart';

part 'rest/abstract_rest_service.dart';
part 'components/route_components/route_config_cmp.dart';
part 'components/route_components/route_logs_cmp.dart';
part 'components/footer_cmp.dart';
part 'components/container_config_cmp.dart';
part 'components/container_menu_list_cmp.dart';
part 'components/container_log_cmp.dart';
part 'components/navbar_right_cmp.dart';
part 'components/navbar_brand_cmp.dart';
part 'injectable/l_configuration.dart';
part 'injectable/l_curator.dart';
part 'es/elastic_search_service.dart';
part 'rest/abstract_rest_service.dart';
part 'es/elastic_search_query_dsl.dart';
part 'models/models.dart';



@Component(
    selector: 'application-main-cmp',
    templateUrl: 'application_main_cmp.html',
    directives: const [NavbarBrandCmp, NavbarRightCmp, FooterCmp, CORE_DIRECTIVES, FORM_DIRECTIVES, ROUTER_DIRECTIVES],
    providers: const [ElasticSearchService, ROUTER_PROVIDERS])
@RouteConfig(const [
  const Route(
      name: ApplicationMainCmp.ROUTE_LOGS_NAME,
      path: '/'  + ApplicationMainCmp.ROUTE_LOGS_PATH,
      component: RouteLogsCmp,
      useAsDefault: true),
  const Route(
      name: ApplicationMainCmp.ROUTE_CONFIG_NAME,
      path: '/'  + ApplicationMainCmp.ROUTE_CONFIG_PATH,
      component: RouteConfigCmp)
])
class ApplicationMainCmp {

    static const String ROUTE_LOGS_PATH = 'logs';
    static const String ROUTE_LOGS_NAME = 'Logs';
    static const String ROUTE_CONFIG_PATH = 'config';
    static const String ROUTE_CONFIG_NAME = 'Config';

}