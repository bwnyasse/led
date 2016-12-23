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
    selector: 'route-remote-api-cmp',
    templateUrl: 'components/route_components/route_remote_api_cmp.html',
    directives: const [ROUTER_DIRECTIVES],
    pipes: const [HumanSize, TruncateId])
@RouteConfig(const [
  const Route(
      name: 'Containers',
      path: '/containers',
      component: RouteDockerContainersListCmp,
      useAsDefault: true),
  const Route(
      name: 'Container',
      path: '/containers/:containerId',
      component: RouteDockerContainerCmp),
  const Route(
      name: 'Images',
      path: '/images',
      component: RouteDockerImagesListCmp)
])
class RouteRemoteApiCmp implements AfterContentInit  {


  LConfiguration configuration;
  DockerRemoteControler dockerRemoteCtrl;
  DockerRemoteConnection connection;

  Timer infoResponseTimer;

  InfoResponse infoResponse;

  RouteRemoteApiCmp(this.configuration, this.dockerRemoteCtrl);


  @override
  ngAfterContentInit() {
    _updateConnection();
  }

  changeNodeIndex() async {
    _updateConnection();
  }

  _updateInfoResponse() async {
    // Info
    infoResponse = await connection.info();
  }

  _updateImagesResponse() async {
    dockerRemoteCtrl.currentImagesInfo = await connection.images();
  }


  _updateContainerResponse() async =>  dockerRemoteCtrl.currentContainers = await connection.containers(all:true);

  _updateConnection() async {
    List connections = configuration.nodesConfiguration.where((config) =>
        quiver_strings.equalsIgnoreCase(
            config.name, configuration.currentNodeIndex));
    if (connections.isNotEmpty) {
      NodeConfiguration currentConfig = configuration.nodesConfiguration
          .where((config) => quiver_strings.equalsIgnoreCase(
          config.name, configuration.currentNodeIndex))
          .first;
      connection = await dockerRemoteCtrl.load(
          host: currentConfig.host, port: currentConfig.port);

      _updateInfoResponse();
      _updateImagesResponse();
      _updateContainerResponse();

      if (infoResponseTimer != null)
        infoResponseTimer.cancel();
      infoResponseTimer =
      new Timer.periodic(const Duration(seconds: 30), (Timer t) async {
        _updateInfoResponse();
        _updateImagesResponse();
        _updateContainerResponse();
      });
    }
  }

  // Bind to template

  getApiVersion() => connection?.dockerVersion?.apiVersion;
  getDockerVersion() =>  connection?.dockerVersion?.version;
  getCpuCount() => infoResponse?.cpuCount;
  getOperatingSystem() => infoResponse?.operatingSystem;
  getMemTotal() => infoResponse?.memTotal;
  getRealHostName() => infoResponse?.name;
  getContainerCount() {
    int count = infoResponse?.containers != null ? infoResponse?.containers : 0;
    return count > 1 ?  count.toString() + " Containers "  : count.toString() + " Container " ;
  }
  getContainerRunningCount() => infoResponse?.containersRunning;
  getContainerStoppedCount() => infoResponse?.containersStopped;
  getContainerPausedCount() => infoResponse?.containersPaused;
  getImagesCount() => ( dockerRemoteCtrl.currentImagesInfo?.length != null && dockerRemoteCtrl.currentImagesInfo?.length > 1 ) ?  dockerRemoteCtrl.currentImagesInfo?.length.toString() + " Images "  : dockerRemoteCtrl.currentImagesInfo?.length.toString() + " Image ";
  getImagesTotalSizeCount() {
    int size = 0;
    dockerRemoteCtrl.currentImagesInfo?.forEach((info) => size += info.size);
    return size;
  }
}