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
import 'dart:math';
import 'dart:js' as js;
import 'dart:convert';
import 'dart:collection';
import "package:js/js.dart";
import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';
import 'package:observable/observable.dart';

import 'package:led_ui/gen/filesize.dart' as gen_filesize;
import 'package:chartjs/chartjs.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:quiver/strings.dart' as quiver_strings;
import 'package:quiver/collection.dart' as quiver_collection;
import 'package:quiver/core.dart' as quiver_core;
import 'package:date/date.dart' as external_date_lib;
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart' as http_browser_client;




import 'utils/utils.dart';
import 'utils/js_interop.dart' as jsinterop;


part 'components/empty.dart';
part 'components/nested_route/container_remote_api_images_cmp.dart';
part 'components/nested_route/route_docker_containers_list_cmp.dart';
part 'components/nested_route/route_docker_images_list_cmp.dart';
part 'components/nested_route/route_docker_container_cmp.dart';
part 'components/route_components/route_config_cmp.dart';
part 'components/route_components/route_logs_cmp.dart';
part 'components/route_components/route_remote_api_cmp.dart';
part 'components/footer_cmp.dart';
part 'components/container_config_cmp.dart';
part 'components/container_menu_list_cmp.dart';
part 'components/container_log_cmp.dart';
part 'components/navbar_right_cmp.dart';
part 'components/navbar_brand_cmp.dart';
part 'injectable/l_configuration.dart';
part 'injectable/l_curator.dart';
part 'pipes/pipes.dart';
part 'es/elastic_search_service.dart';
part 'es/elastic_search_query_dsl.dart';
part 'rest/abstract_rest_service.dart';
part 'es/models.dart';
part 'dra/models.dart';
part 'dra/docker_remote_connection.dart';
part 'dra/docker_remote_controler.dart';

@Component(
    selector: 'application-main-cmp',
    templateUrl: 'application_main_cmp.html',
    directives: const [
      NavbarBrandCmp,
      NavbarRightCmp,
      FooterCmp,
      CORE_DIRECTIVES,
      FORM_DIRECTIVES,
      ROUTER_DIRECTIVES
    ],
    providers: const [
      ElasticSearchService, LConfiguration, LCurator, DockerRemoteControler,
      ROUTER_PROVIDERS,
      const Provider(LocationStrategy, useClass: HashLocationStrategy)
    ])
@RouteConfig(const [
  const Route(
      name: 'Logs',
      path: '/logs',
      component: RouteLogsCmp,
      useAsDefault: true),
  const Route(
      name: 'Config',
      path: '/config',
      component: RouteConfigCmp),
  const Route(
      name: 'Remoteapi',
      path: '/remoteapi/...',
      component: RouteRemoteApiCmp)
])
class ApplicationMainCmp {
}