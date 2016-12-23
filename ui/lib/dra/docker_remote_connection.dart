/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 21/12/16
 * Author     : bwnyasse
 *  
 */
part of led_ui;

class DockerRemoteConnection {

  Uri hostServer;
  
  final Map _headersJson = {'Content-Type': 'application/json'};
  final Map _headersTar = {'Content-Type': 'application/tar'};

  ServerReference _serverReference;
  ServerReference get serverReference => _serverReference;

  VersionResponse _dockerVersion;
  VersionResponse get dockerVersion => _dockerVersion;

  DockerRemoteConnection(Uri hostServer,http.Client client) {
    assert(hostServer != null);
    assert(client != null);
    _serverReference = new ServerReference(hostServer, client);
  }

  Version get apiVersion {
    if (dockerVersion == null) {
      return null;
    }
    return dockerVersion.apiVersion;
  }

  /// Loads the version information from the Docker service.
  /// The version information is used to adapt to differences in the Docker
  /// remote API between different Docker version.
  /// If [init] isn't called no version specific handling can be done.
  Future init() async {
    if (_dockerVersion == null) {
      _dockerVersion = await version();
    }
  }

  /// Show Docker version information.
  /// Status Codes:
  /// 200 - no error
  /// 500 - server error
  Future<VersionResponse> version() async {
    final Map response = await _request(RequestType.get, '/version');
    return new VersionResponse.fromJson(response, apiVersion);
  }

  /// Get system-wide information.
  /// Status Codes:
  /// 200 - no error
  /// 500 - server error
  Future<InfoResponse> info() async {
    final Map response = await _request(RequestType.get, '/info');
    return new InfoResponse.fromJson(response, apiVersion);
  }

  /// List images.
  /// The response shows a single image `Id` associated with two repositories
  /// (`RepoTags`): `localhost:5000/test/busybox`: and `playdate`. A caller can
  /// use either of the `RepoTags` values `localhost:5000/test/busybox:latest`
  /// or `playdate:latest` to reference the image.
  ///
  /// You can also use `RepoDigests` values to reference an image. In this
  /// response, the array has only one reference and that is to the
  /// `localhost:5000/test/busybox` repository; the `playdate` repository has no
  /// digest. You can reference this digest using the value:
  /// `localhost:5000/test/busybox@sha256:cbbf2f9a99b47fc460d...`
  ///
  /// See the `docker run` and `docker build` commands for examples of digest
  /// and tag references on the command line.
  ///
  /// Query Parameters:
  ///
  /// [all] - Show all images (by default filter out the intermediate image
  ///     layers). The default is false.
  /// [filters] - a json encoded value of the filters (a map[string][]string) to
  ///     process on the images list. Available filters: dangling=true
  Future<Iterable<ImageInfo>> images(
      {bool all, Map<String, List> filters}) async {
    Map<String, String> query = {};
    if (all != null) query['all'] = all.toString();
    if (filters != null) query['filters'] = JSON.encode(filters);

    final List response =
    await _request(RequestType.get, '/images/json', query: query);
    return response.map((e) => new ImageInfo.fromJson(e, apiVersion));
  }

  /// Request the list of containers from the Docker service.
  /// [all] - Show all containers. Only running containers are shown by default
  /// (i.e., this defaults to false)
  /// [limit] - Show limit last created containers, include non-running ones.
  /// [since] - Show only containers created since Id, include non-running ones.
  /// [before] - Show only containers created before Id, include non-running
  /// ones.
  /// [size] - Show the containers sizes
  /// [filters] - filters to process on the containers list. Available filters:
  ///  `exited`=<[int]> - containers with exit code of <int>
  ///  `status`=[ContainerStatus]
  ///  Status Codes:
  /// 200 – no error
  /// 400 – bad parameter
  /// 500 – server error
  Future<Iterable<Container>> containers({bool all, int limit, String since,
  String before, bool size, Map<String, List> filters}) async {
    Map<String, String> query = {};
    if (all != null) query['all'] = all.toString();
    if (limit != null) query['limit'] = limit.toString();
    if (since != null) query['since'] = since;
    if (before != null) query['before'] = before;
    if (size != null) query['size'] = size.toString();
    if (filters != null) query['filters'] = JSON.encode(filters);

    final List response =
    await _request(RequestType.get, '/containers/json', query: query);
//    print(response);
    return response.map((e) => new Container.fromJson(e, apiVersion));
  }

  /// Return low-level information of [container].
  /// The passed [container] argument must have an existing id assigned.
  /// Status Codes:
  /// 200 – no error
  /// 404 – no such container
  /// 500 – server error
  Future<ContainerInfo> container(Container container) async {
    assert(
    container != null && container.id != null && container.id.isNotEmpty);
    final Map response =
    await _request(RequestType.get, '/containers/${container.id}/json');
//    print(response);
    return new ContainerInfo.fromJson(response, apiVersion);
  }


  Future<dynamic> _request(RequestType requestType, String path,
      {Map body, Map query, Map<String,
          String> headers, ResponsePreprocessor preprocessor}) async {
    assert(requestType != null);
    assert(body == null);
    String data;
    if (body != null) {
      data = JSON.encode(body);
    }
    Map<String, String> _headers = headers != null ? headers : _headersJson;

    final url = serverReference.buildUri(path, query);

    http.Response response;
    switch (requestType) {
      case RequestType.get:
        response = await serverReference.client.get(url, headers: _headers);
        break;
      default:
        throw '"${requestType}" not implemented.';
    }

    if ((response.statusCode < 200 || response.statusCode >= 300) &&
        response.statusCode != 304) {
      throw new DockerRemoteApiError(
          response.statusCode, response.reasonPhrase, response.body);
    }
    if (response.body != null && response.body.isNotEmpty) {
      var data = response.body;
      if (preprocessor != null) {
        data = preprocessor(response.body);
      }
      try {
        return JSON.decode(data);
      } catch (e) {
        print(data);
      }
    }
    return null;
  }
}