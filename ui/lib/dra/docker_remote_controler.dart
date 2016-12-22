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

@Injectable()
class DockerRemoteControler {

  List<Container> currentContainers = [];
  List<ImageInfo> currentImagesInfo = [];

  Map<String, DockerRemoteConnection> dockerRemoteConnections = new Map();

  Future<DockerRemoteConnection> load({String host, String port}) async {
    Uri hostServer = _getUri(host, port);
    String key = hostServer.toString();
    DockerRemoteConnection connection;
    if(dockerRemoteConnections.containsKey(key)){
      connection = dockerRemoteConnections[key];
    }else{
      connection= new DockerRemoteConnection(hostServer, new http_browser_client.BrowserClient());
      dockerRemoteConnections[key] = connection;
      await connection.init();
    }
    return connection;
  }

  Uri _getUri(String host, String port) => Uri.parse('http://$host:$port');
}