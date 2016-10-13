/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 13/10/16
 * Author     : bwnyasse
 *  
 */
part of fluentd_log_explorer;

@Injectable()
class LCurator extends AbstractRestService {

  static String CURATOR_REST_URL = AbstractRestService.CONTEXT_URL +"/server/_api/curator";

  CleanCuratorConfig cleanCuratorConfig = new CleanCuratorConfig();

  callCurator() async {
    String url = CURATOR_REST_URL + "/" + cleanCuratorConfig.olderThan.toString();
    _get(url).then((response) {
      print(response.responseText);
    });
  }
}