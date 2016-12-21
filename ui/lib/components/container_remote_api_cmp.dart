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
    directives: const [ROUTER_DIRECTIVES, FORM_DIRECTIVES],
    pipes: const [HumanSize])
class ContainerRemoteApiCmp implements AfterContentInit {

  ElasticSearchService service;
  LConfiguration configuration;
  DockerRemoteControler dockerRemoteCtrl;
  DockerRemoteConnection connection;
  bool showContainerBox = true;
  bool initShow = false;
  List<ImageInfo> imagesInfo = [];
  List<Container> containers = [];

  Timer infoResponseTimer;

  InfoResponse infoResponse;

  ContainerRemoteApiCmp(this.service, this.configuration,
      this.dockerRemoteCtrl);


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

  _updateImagesResponse() async => imagesInfo = await connection.images();

  _updateContainerResponse() async => containers = await connection.containers(all:true);

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

  showContainer(bool value) {
    initShow = true;
    showContainerBox = value;
  }
  // Bind to template

  getApiVersion() => connection?.dockerVersion?.apiVersion;
  getDockerVersion() =>  connection?.dockerVersion?.version;
  getCpuCount() => infoResponse?.cpuCount;
  getOperatingSystem() => infoResponse?.operatingSystem;
  getMemTotal() => infoResponse?.memTotal;
  getRealHostName() => infoResponse?.name;
  getContainerCount() => infoResponse?.containers;
  getContainerRunningCount() => infoResponse?.containersRunning;
  getContainerStoppedCount() => infoResponse?.containersStopped;
  getContainerPausedCount() => infoResponse?.containersPaused;
  getImagesCount() => imagesInfo?.length;
  getImagesTotalSizeCount() {
    int size = 0;
    imagesInfo.forEach((info) => size += info.size);
    return size;
  }
}
