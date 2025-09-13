import 'package:config_runtime/config_runtime.dart';
import 'package:test/test.dart';

void main() {
  test('PackManifest fromMap -> toJson roundtrip', () {
    final map = {
      'name': 'example-pack',
      'engine': 'demo-engine',
      'tags': ['alpha', 'test'],
      'lockSeed': true,
      'locales': ['en', 'fr'],
      'requiresSubs': false,
      'risk': 'experimental',
    };

    final manifest = PackManifest.fromMap(Map<String, dynamic>.from(map));
    final json = manifest.toJson();

    expect(json['name'], equals('example-pack'));
    expect(json['engine'], equals('demo-engine'));
    expect(json['tags'], contains('alpha'));
    expect(json['lockSeed'], isTrue);
    expect(json['locales'], contains('fr'));
    expect(json['risk'], equals('experimental'));
  });
}
