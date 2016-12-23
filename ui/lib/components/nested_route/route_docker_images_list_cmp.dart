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

class AvailableColors {
  String backgroundColor;
  String borderColor;

  AvailableColors(this.backgroundColor, this.borderColor);
}

@Component(
    selector: 'route-docker-images-list-cmp',
    templateUrl: 'components/nested_route/route_docker_images_list_cmp.html',
    directives: const [ROUTER_DIRECTIVES, FORM_DIRECTIVES],
    pipes: const [HumanSize, TruncateId])
class RouteDockerImagesListCmp implements AfterContentInit {

  DockerRemoteControler dockerRemoteCtrl;
  CanvasRenderingContext2D ctx;

  RouteDockerImagesListCmp(this.dockerRemoteCtrl);

  List<AvailableColors> availableColors = [];

  containerStatusColor(String value) {
    if (value.contains('Up')) {
      return "color-success";
    } else if (value.contains('Exited')) {
      return "color-red";
    }
  }

  initColor() {
    availableColors.add(
        new AvailableColors('rgba(255, 99, 132, 0.2)', 'rgba(255,99,132,1)'));
    availableColors.add(new AvailableColors(
        'rgba(54, 162, 235, 0.2)', 'rgba(54, 162, 235, 1)'));
    availableColors.add(new AvailableColors(
        'rgba(255, 206, 86, 0.2)', 'rgba(255, 206, 86, 1)'));
    availableColors.add(new AvailableColors(
        'rgba(75, 192, 192, 0.2)', 'rgba(75, 192, 192, 1)'));
    availableColors.add(new AvailableColors(
        'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 1)'));
    availableColors.add(new AvailableColors(
        'rgba(255, 159, 64, 0.2)', 'rgba(255, 159, 64, 1)'));
  }

  /**
   * Generates a positive random integer uniformly distributed on the range
   * from [min], inclusive, to [max], exclusive.
   */
  static int next(int min, int max) => min + new Random().nextInt(max - min);

  @override
  ngAfterContentInit() async {
    initColor();
    ctx = (querySelector('#image-size-chart') as CanvasElement).context2D;
    initImageSizeChart();
  }


  initImageSizeChart() {
    ctx.restore();
    ctx.resetTransform();
    List imageReadData = [];
    List backgroundColorData = [];
    List borderColorData = [];
    List imageData = [];

    dockerRemoteCtrl.currentImagesInfo?.forEach((imageInfo) {
      int index = next(0, 6);
      imageReadData.add(imageInfo.repoTags.toString());
      imageData.add(imageInfo.size.toString());
      backgroundColorData.add(availableColors
          .elementAt(index)
          .backgroundColor.toString());
      borderColorData.add(availableColors
          .elementAt(index)
          .borderColor.toString());
    });
    LinearChartData data = new LinearChartData(
        labels: imageReadData,
        datasets: <ChartDataSets>[
      new ChartDataSets(
          label: "Image Size Bar en KB",
          backgroundColor: backgroundColorData,
          borderColor: borderColorData,
          borderWidth: 1,
          data: imageData)
    ]);
    ChartConfiguration config = new ChartConfiguration(
        type: 'bar',
        data: data,
        options: new ChartOptions(responsive: true));

    Chart cpuChart = new Chart(ctx, config);
  }


}