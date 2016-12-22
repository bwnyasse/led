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
    selector: 'route-docker-container-cmp',
    templateUrl: 'components/nested_route/route_docker_container_cmp.html',
    directives: const [ROUTER_DIRECTIVES, FORM_DIRECTIVES],
    pipes: const [HumanSize, TruncateId])
class RouteDockerContainerCmp implements AfterContentInit {

  LConfiguration configuration;
  DockerRemoteControler dockerRemoteCtrl;
  RouteParams routeParams;
  ContainerInfo containerInfo;
  String containerId;


  RouteDockerContainerCmp(this.configuration, this.dockerRemoteCtrl, this.routeParams);

  @override
  ngAfterContentInit() async {
    containerId = routeParams.get('containerId');
    containerInfo = await dockerRemoteCtrl.currentConnection?.container(new Container(containerId));
  }

  getJson() =>  containerInfo?._asPrettyJson;
  getContainerName() => containerInfo?.name;
  getContainerId() => containerInfo?.id;
  getContainerImage() => containerInfo?.config?.image;
  getContainerStatus() => containerInfo?.state?.status;
  getContainerDriver() => containerInfo?.driver;
  getContainerCmd() => containerInfo?.config?.cmd;
  getExposedPorts() => containerInfo?.config?.exposedPorts;
  getEnv() => containerInfo?.config?.env;
}