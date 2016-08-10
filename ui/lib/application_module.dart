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
library fluentd_log_explorer;

@MirrorsUsed(targets: const ['fluentd_log_explorer'], override: '*')
import 'dart:mirrors';
import 'dart:async';
import 'dart:html';

import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:fluentd_log_explorer/utils/js_interop.dart' as jsinterop;
import 'package:quiver/strings.dart' as quiver_strings;
import 'package:quiver/collection.dart' as quiver_collection;
import 'package:fluentd_log_explorer/utils/utils.dart';

part 'components/container_menu_list_cmp.dart';
part 'components/container_log_cmp.dart';
part 'package:fluentd_log_explorer/es/elastic_search_service.dart';
part 'rest/abstract_rest_service.dart';
part 'package:fluentd_log_explorer/es/elastic_search_query_dsl.dart';

part 'containers/wildfly/wildfly_search_service.dart';

class ApplicationModule extends Module {
  ApplicationModule() {
    // Wildfly
    bind(WildflySearchService);

    bind(ContainerMenuListCmp);
    bind(ContainerLogCmp);
    bind(ElasticSearchService);
    // Routing Mechanism
//    bind(RouteInitializerFn, toImplementation: MRouter);
//    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
  }
}
