/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 16/09/16
 * Author     : bwnyasse
 *  
 */
part of fluentd_log_explorer;

@Component(
    selector: 'container-config-cmp',
    templateUrl:
    'packages/fluentd_log_explorer/components/container_config_cmp.html',
    useShadowDom: false)
class ContainerConfigCmp extends ShadowRootAware {

  ElasticSearchService service;
  LConfiguration configuration;
  List levelConfigurations;
  List getLogTagFormat;
  ContainerConfigCmp(this.service,this.configuration);

  @override
  void onShadowRoot(ShadowRoot shadowRoot) {
    levelConfigurations= configuration.getLevelsConfiguration();
    getLogTagFormat= configuration.getLogTagFormat();
    jsinterop.initJSC();
  }

  register() => print(levelConfigurations.toString());
}