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
part of led_ui;

@Component(
    selector: 'footer-cmp',
    templateUrl:
    'packages/fluentd_log_explorer/components/footer_cmp.html',
    useShadowDom: false)
class FooterCmp {

  String version;

  FooterCmp(){
    version = jsinterop.APP_VERSION;
  }
}