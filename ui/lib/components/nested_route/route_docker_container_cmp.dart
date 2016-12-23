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
  String cpuPercentS;
  int memUsage;
  int memLimit;
  Queue<String> receiveCpuPercentS = new Queue();
  Queue<String> receiveReadS = new Queue();

  var ctx;

  List cpuPercentData = [];
  List cpuPercentReadData = [];
  Chart cpuChart;

  RouteDockerContainerCmp(this.configuration, this.dockerRemoteCtrl, this.routeParams);

  @override
  ngAfterContentInit() async {
    containerId = routeParams.get('containerId');
    containerInfo = await dockerRemoteCtrl.currentConnection?.container(new Container(containerId));
    ctx = (querySelector('#cpu-stats-chart') as CanvasElement).context2D;
    requestStream2();
  }

  initCpuChart() {

    LinearChartData data = new LinearChartData(labels: cpuPercentReadData, datasets: <ChartDataSets>[
      new ChartDataSets(
          label: "cpu percent",
          backgroundColor: "rgba(151,187,205,0.5)",
          borderColor: "rgba(151,187,205,1)",
          pointBackgroundColor: "rgba(151,187,205,1)",
          data: cpuPercentData)
    ]);
    ChartConfiguration config = new ChartConfiguration(type: 'line', data: data, options: new ChartOptions(responsive: true));

    Chart cpuChart = new Chart(ctx, config);

    new Timer.periodic(const Duration(seconds: 3), (Timer t) {
      cpuPercentReadData.add(receiveReadS.last);
      cpuPercentData.add(receiveCpuPercentS.last);
      cpuChart.update();
      receiveReadS.clear();
      receiveCpuPercentS.clear();
    });
  }

  requestStream2() {
   initCpuChart();
    ResponseStream stream = new ResponseStream();
    stream.flow.listen((String data) {
      try {
        Map json = JSON.decode(data);
        StatsResponse statsResponse = new StatsResponse.fromJson(json, null);
        String readS = statsResponse.read.toLocal().toString();
        cpuPercentS = cpuPercent(statsResponse).toString();
        memUsage = statsResponse.memoryStats.usage;
        memLimit = statsResponse.memoryStats.limit;
        receiveReadS.add(readS);
        receiveCpuPercentS.add(cpuPercentS);
      } catch (e) {
        //Nothing to show if decode failed
      }
    });
    HttpRequest req = new HttpRequest();
    String url = dockerRemoteCtrl.currentConnection.hostServer.toString();
    print(url);
    req.open('GET', '$url/containers/$containerId/stats',
        async: true);
    req.onProgress.listen((ProgressEvent e) {
      stream.add(req.responseText);
    });
    req.send();
  }

  cpuPercent(StatsResponse statsResponse) {
    // Same algorithm the official client uses: https://github.com/docker/docker/blob/master/api/client/stats.go#L195-L208
    StatsResponseCpuStats preCpu = statsResponse.preCpuStats;
    StatsResponseCpuStats curCpu = statsResponse.cpuStats;

    var cpuPercent = 0.0;

    // calculate the change for the cpu usage of the container in between readings
    var cpuDelta = curCpu.cupUsage.totalUsage - preCpu.cupUsage.totalUsage;
    // calculate the change for the entire system between readings
    var systemDelta = curCpu.systemCpuUsage - preCpu.systemCpuUsage;
    if (systemDelta > 0.0 && cpuDelta > 0.0) {
      cpuPercent = (cpuDelta / systemDelta) * curCpu.cupUsage.perCpuUsage.length * 100.0;
    }
    return cpuPercent;
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