/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 11/08/16
 * Author     : bwnyasse
 *  
 */
part of fluentd_log_explorer;

@Injectable()
class ContainerService {

  ElasticSearchService esService;

  ContainerService(this.esService);

  retryFormat(Input input) {
    Map json = new Map();

    //WILDFLY
    if(quiver_strings.equalsIgnoreCase(input.container_type,WildflyService.CONTAINER_TYPE)){
      json.addAll(Utils.retryFormatWildfly(log: input.log));
    }

    if(json.isNotEmpty){
      // Update to ES
      esService.retryUpdateLogFormat(type:input.type,id:input.id,suffix:json['suffix'],level:json['level'],message:json['message']);
    }
  }
}