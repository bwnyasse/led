@JS()
library ui_jsinterop;

import "package:js/js.dart";
import 'dart:js' as js;
import 'package:quiver/strings.dart' as quiver_strings;

////////////////////////// Call -> [env.js] /////////////////////////////////////
var APP_NAME =
    quiver_strings.isEmpty(js.context['env']['APP_NAME'])
        ? ''
        : js.context['env']['APP_NAME'];
var ES_SERVER_HOST_ADDRESS =
    quiver_strings.isEmpty(js.context['env']['ES_SERVER_HOST_ADDRESS'])
        ? '0.0.0.0'
        : js.context['env']['ES_SERVER_HOST_ADDRESS'];
var ES_PORT = quiver_strings.isEmpty(js.context['env']['ES_PORT'])
    ? '9200'
    : js.context['env']['ES_PORT'];
var ES_INDEX = quiver_strings.isEmpty(js.context['env']['ES_INDEX'])
    ? 'fluentd'
    : js.context['env']['ES_INDEX'];
var APP_CONTEXT_URL = quiver_strings.isEmpty(js.context['env']['APP_CONTEXT_URL'])
    ? ''
    : js.context['env']['APP_CONTEXT_URL'];
////////////////////////// Call -> [infos.js] /////////////////////////////////////
var APP_VERSION =
quiver_strings.isEmpty(js.context['infos']['APP_VERSION'])
    ? 'development'
    : js.context['infos']['APP_VERSION'];


////////////////////////// Call --> [notie.js]  /////////////////////////////////

const int SHOW_NOTIE_TIME_IN_SECOND = 2;

showNotieSuccess(String message) {
  notieAlert(1, message, SHOW_NOTIE_TIME_IN_SECOND);
}

showNotieWarning(String message) {
  notieAlert(2, message, SHOW_NOTIE_TIME_IN_SECOND);
}

showNotieError(String message) {
  notieAlert(3, message, SHOW_NOTIE_TIME_IN_SECOND);
}

@JS("notie.alert")
external String notieAlert(int styleNumber, String message, int timeInSecond);

@JS("initJSC")
external String initJSC();
