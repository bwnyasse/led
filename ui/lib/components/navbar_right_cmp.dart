/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 02/09/16
 * Author     : bwnyasse
 *  
 */
part of fluentd_log_explorer;

@Component(
    selector: 'navbar-right-cmp',
    templateUrl:
    'packages/fluentd_log_explorer/components/navbar_right_cmp.html',
    useShadowDom: false)
class NavbarRightCmp {

  ElasticSearchService service;

  NavbarRightCmp(this.service);

  refresh() => service.refresh();
}