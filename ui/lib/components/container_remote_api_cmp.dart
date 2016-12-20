/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 20/12/16
 * Author     : bwnyasse
 *  
 */
part of led_ui;

@Component(
    selector: 'container-remote-api-cmp',
    templateUrl: 'components/container_remote_api_cmp.html',
    directives: const [ROUTER_DIRECTIVES, FORM_DIRECTIVES])
class ContainerRemoteApiCmp  implements OnInit {

  ElasticSearchService service;
  LConfiguration configuration;

  ContainerRemoteApiCmp(this.service, this.configuration);

  @override
  ngOnInit() {
    // TODO: implement ngOnInit
  }

  changeNodeIndex() {

  }
}