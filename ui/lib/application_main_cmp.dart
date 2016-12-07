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


@MirrorsUsed(targets: const ['led_ui'], override: '*')
import 'dart:mirrors';
import 'dart:async';
import 'dart:html';
import 'dart:js' as js;
import 'dart:convert';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';

import 'package:intl/intl.dart';
import 'package:led_ui/utils/js_interop.dart' as jsinterop;
import 'package:quiver/strings.dart' as quiver_strings;
import 'package:quiver/collection.dart' as quiver_collection;
import 'package:quiver/core.dart' as quiver_core;
import 'package:date/date.dart' as external_date_lib;

import 'package:led_ui/utils/utils.dart';

part 'components/footer_cmp.dart';
part 'components/container_config_cmp.dart';
part 'components/container_menu_list_cmp.dart';
part 'components/container_log_cmp.dart';
part 'components/navbar_right_cmp.dart';
part 'components/navbar_brand_cmp.dart';
part 'injectable/l_router.dart';
part 'injectable/l_configuration.dart';
part 'injectable/l_curator.dart';
part 'package:led_ui/es/elastic_search_service.dart';
part 'rest/abstract_rest_service.dart';
part 'package:led_ui/es/elastic_search_query_dsl.dart';
part 'models/models.dart';



@Component(
    selector: 'application-main-cmp',
    templateUrl: 'application_main_cmp.html',
    // TODO: Add directives for nested components
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES, ROUTER_DIRECTIVES],
    providers: const [ROUTER_PROVIDERS])
class ApplicationMainCmp {

}