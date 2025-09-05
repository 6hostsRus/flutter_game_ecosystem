import 'package:flutter_test/flutter_test.dart';
import 'package:providers/registry/feature_registry.dart';

void main() {
  group('MutableFeatureRegistry', () {
    test('upsert + list adds feature', () {
      final reg = MutableFeatureRegistry();
      final f = Feature(
          id: 'home',
          title: 'Home',
          nav: [NavEntry(id: 'home', iconKey: 'home', label: 'Home')]);
      reg.upsert(f);
      expect(reg.list().length, 1);
    });

    test('upsert updates existing feature', () {
      final reg = MutableFeatureRegistry();
      reg.upsert(const Feature(id: 'store', title: 'Store', nav: []));
      reg.upsert(const Feature(id: 'store', title: 'Shop', nav: []));
      expect(reg.list().single.title, 'Shop');
    });

    test('remove deletes feature', () {
      final reg = MutableFeatureRegistry();
      reg.upsert(const Feature(id: 'inv', title: 'Inventory', nav: []));
      reg.remove('inv');
      expect(reg.list(), isEmpty);
    });

    test('watch emits on changes', () async {
      final reg = MutableFeatureRegistry();
      final events = <List<Feature>>[];
      final sub = reg.watch().listen(events.add);
      reg.upsert(const Feature(id: 'a', title: 'A', nav: []));
      reg.upsert(const Feature(id: 'b', title: 'B', nav: []));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(events.length, greaterThanOrEqualTo(2));
      await sub.cancel();
      reg.dispose();
    });
  });
}
