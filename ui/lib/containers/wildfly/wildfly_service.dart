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

@Injectable()
class WildflyService  {

  static String CONTAINER_TYPE = "wildfly";

  retryFormat(String log) {
    Map json = Utils.retryFormatWildfly(log: log);
    if(json.isNotEmpty){
      // Update to ES
    }
  }
}
