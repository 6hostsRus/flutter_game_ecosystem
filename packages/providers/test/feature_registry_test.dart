import 'package:flutter_test/flutter_test.dart';
import 'package:providers/registry/feature_registry.dart';

void main() {
  test('MutableFeatureRegistry upsert + list', () {
    final reg = MutableFeatureRegistry();
    final f = Feature(id: 'home', title: 'Home', nav: [NavEntry(id: 'home', iconKey: 'home', label: 'Home')]);
    reg.upsert(f);
    expect(reg.list().length, 1);
  });
}
