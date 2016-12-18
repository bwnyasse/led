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
part of led_ui;

@Component(
    selector: 'container-config-cmp',
    templateUrl: 'components/container_config_cmp.html')
class ContainerConfigCmp implements AfterViewInit {

  ElasticSearchService service;
  LConfiguration configuration;
  LCurator curator;
  List levelConfigurations = [];
  List nodesConfigurations = [];
  List getLogTagFormat;
  ContainerConfigCmp(this.service,this.configuration,this.curator);

  // FIXME: migrate to ng2, ngModel don't work with jscolor , so I add updateColor for binding
  updateColor(name, value) =>
    levelConfigurations.where((config) => quiver_strings.equalsIgnoreCase(config.name,name)).single.color = "#$value";

  removeNodes(String id) => nodesConfigurations.removeWhere((config) => quiver_strings.equalsIgnoreCase(id,config.id));

  addNodes() => nodesConfigurations.add(new NodeConfiguration.empty());

  registerNodes() {

    bool isValid = true;
    nodesConfigurations.forEach((NodeConfiguration config) {
      isValid = isValid && config.isValid();
      print(config);
    });
    isValid && _save();
  }

  registerLevels() => _save();

  performCurator() => curator.callCurator();

  _save() => configuration.saveConfig(nodesConfigurations,levelConfigurations);

  @override
  ngAfterViewInit() {
    nodesConfigurations = configuration.getNodesConfiguration();
    levelConfigurations= configuration.getLevelsConfiguration();
    getLogTagFormat= configuration.getLogTagFormat();
    jsinterop.initJSC();
  }

}