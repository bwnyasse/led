@JS()
library ui_jsinterop;

import "package:js/js.dart";

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
