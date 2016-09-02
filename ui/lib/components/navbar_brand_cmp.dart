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
    selector: 'navbar-brand-cmp',
    templateUrl:
    'packages/fluentd_log_explorer/components/navbar_brand_cmp.html',
    useShadowDom: false)
class NavbarBrandCmp {

  String brandName;

  NavbarBrandCmp(){
    brandName = jsinterop.APP_NAME;
  }

}