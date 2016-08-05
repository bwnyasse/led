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

@Component(
    selector: 'container-log-cmp',
    templateUrl: 'packages/fluentd_log_explorer/components/container_log_cmp.html',
    useShadowDom: false)
class ContainerLogCmp {

  ElasticSearchService service;

  ContainerLogCmp(this.service){
    service.getAvailableContainerIndexes();
  }

  getLogMessage(source) => source['log'];
  getTime(source) => source['@timestamp'];
  getOutput(source) => source['source'];
}