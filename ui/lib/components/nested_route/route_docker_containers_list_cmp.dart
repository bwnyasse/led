/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 22/12/16
 * Author     : bwnyasse
 *  
 */
part of led_ui;

@Component(
    selector: 'route-docker-containers-list-cmp',
    templateUrl: 'components/nested_route/route_docker_containers_list_cmp.html',
    directives: const [ROUTER_DIRECTIVES, FORM_DIRECTIVES],
    pipes: const [HumanSize, TruncateId])
class RouteDockerContainersListCmp  {

  DockerRemoteControler dockerRemoteCtrl;

  RouteDockerContainersListCmp(this.dockerRemoteCtrl);

  containerStatusColor(String value) {
    if(value.contains('Up')){
      return "color-success";
    }else if(value.contains('Exited')){
      return "color-red";
    }
  }

}