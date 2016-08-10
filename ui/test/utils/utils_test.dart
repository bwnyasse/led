import 'package:fluentd_log_explorer/utils/utils.dart';
import 'package:test/test.dart';
import 'package:quiver/collection.dart' as quiver_collection;

main() {
  test('test Utils#retryFormatWildfly', () {
    var input = """
[0m[31m22:25:57,366 ERROR [org.jboss.msc.service.fail] (MSC service thread 1-8) MSC000001: Failed to start service jboss.deployment.unit."bad.war"
  """;
    var json = new Map();
    json['suffix'] = '[0m[31m';
    json['time'] = '22:25:57,366';
    json['level'] = 'ERROR';
    json['message'] =
        '[org.jboss.msc.service.fail] (MSC service thread 1-8) MSC000001: Failed to start service jboss.deployment.unit."bad.war"';
    var result = Utils.retryFormatWildfly(log: input);
    expect(json, result);
    expect(true, quiver_collection.mapsEqual(json, result));
  });
}
