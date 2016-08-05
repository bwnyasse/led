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
    selector: 'container-menu-list-cmp',
    templateUrl: 'packages/fluentd_log_explorer/components/container_menu_list_cmp.html',
    useShadowDom: false)
class ContainerMenuListCmp {

  ElasticSearchService service;

  ContainerMenuListCmp(this.service){
    service.getAvailableContainerIndexes();
  }

  getContainerLog(String index) => service.getContainerLogs(index);
}