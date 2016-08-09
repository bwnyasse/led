@JS()
library ui_jsinterop;

import "package:js/js.dart";
import 'dart:js' as js;
import 'package:quiver/strings.dart' as quiver_strings;

////////////////////////// Call -> [env.js] /////////////////////////////////////

var ES_BROWSER_HOST = quiver_strings.isEmpty(js.context['env']['ES_BROWSER_HOST']) ? '0.0.0.0' : js.context['env']['ES_BROWSER_HOST'];
var ES_PORT = quiver_strings.isEmpty(js.context['env']['ES_PORT']) ? '9200' : js.context['env']['ES_PORT'];
var ES_INDEX = quiver_strings.isEmpty(js.context['env']['ES_INDEX']) ? 'fluentd' : js.context['env']['ES_INDEX'];

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

