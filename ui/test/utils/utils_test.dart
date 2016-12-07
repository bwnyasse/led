import 'package:led_ui/utils/utils.dart';
import 'package:test/test.dart';
import 'package:quiver/collection.dart' as quiver_collection;

main() {

  ///
  ///
  test('test Utils#retryFormatWildfly', () {
    var input = """
[0m[31m22:25:57,366 ERROR [org.jboss.msc.service.fail] (MSC service thread 1-8) MSC000001: Failed to start service jboss.deployment.unit."bad.war"
  """;
    var json = new Map();
    json['time_forward'] = '22:25:57,366';
    json['level'] = 'ERROR';
    json['message'] =
        '[org.jboss.msc.service.fail] (MSC service thread 1-8) MSC000001: Failed to start service jboss.deployment.unit."bad.war"';
    var result = Utils.retryFormatWildfly(log: input);
    expect(json, result);
    expect(true, quiver_collection.mapsEqual(json, result));
  });

  ///
  ///
  test('test Utils#retryFormatWildflyMultiLine', () {
    var input = """
[0m[31m22:25:57,366 ERROR [org.jboss.msc.service.fail] (MSC service thread 1-8) MSC000001: Failed to start service jboss.deployment.unit."bad.war \n line1 \n line2 "
  """;
    var json = new Map();
    json['time_forward'] = '22:25:57,366';
    json['level'] = 'ERROR';
    json['message'] =
    '[org.jboss.msc.service.fail] (MSC service thread 1-8) MSC000001: Failed to start service jboss.deployment.unit."bad.war \n line1 \n line2 "';
    var result = Utils.retryFormatWildfly(log: input);
    expect(json, result);
    expect(true, quiver_collection.mapsEqual(json, result));
  });


  ///
  ///
  test('test Utils#retryFormatMongo', () {
    var input = """
    2014-11-03T18:28:32.450-0500 I NETWORK [initandlisten] waiting for connections on port 27017
    """;
    var json = new Map();
    json['time_forward'] = '18:28:32.450';
    json['level'] = 'I';
    json['message'] =
    'NETWORK [initandlisten] waiting for connections on port 27017';
    var result = Utils.retryFormatMongo(log: input);
    expect(json, result);
    expect(true, quiver_collection.mapsEqual(json, result));
  });

  ///
  ///
  test('test Utils#retryFormatMongoMultiLine', () {
    var input = """
    2014-11-03T18:28:32.450-0500 I NETWORK [initandlisten] waiting for connections on port 27017 \n line1 \n line2
    """;
    var json = new Map();
    json['time_forward'] = '18:28:32.450';
    json['level'] = 'I';
    json['message'] =
    'NETWORK [initandlisten] waiting for connections on port 27017 \n line1 \n line2';
    var result = Utils.retryFormatMongo(log: input);
    expect(json, result);
    expect(true, quiver_collection.mapsEqual(json, result));
  });
}
