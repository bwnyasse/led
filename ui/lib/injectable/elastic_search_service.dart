/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 05/08/16
 * Author     : bwnyasse
 *  
 */
part of fluentd_log_explorer;

@Injectable()
class ElasticSearchService {

  static String INDEX_URL = " http://localhost/es/_aliases?pretty=1";

  List<String> availableContainerIndexes = [];
  List currentLogsSource = [];

  getAvailableContainerIndexes() async {
    availableContainerIndexes.clear();
    _get(INDEX_URL).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      availableContainerIndexes = jsonResponse.keys.toList();
      print(availableContainerIndexes.toString());
    });
  }

  getContainerLogs(String index) async {
    String url = "http://localhost/es/$index/_search?pretty=1'";
    currentLogsSource.clear();
    _get(url).then((HttpRequest response) {
      Map jsonResponse = JSON.decode(response.responseText);
      List listHists = jsonResponse['hits']['hits'];
      listHists.forEach((hists){
        currentLogsSource.add(hists['_source']);
      });
    });
  }

  ///
  /// Appel d'une [url] en 'GET'
  ///
  Future<HttpRequest> _get(String url) async
  {
    Future<HttpRequest> httpRequest = HttpRequest.request(url, method: 'GET');
    return httpRequest;
  }


}