import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

void main() {
  test('CategoryRegistry filters enabled descriptors', () {
    const reg = CategoryRegistry([
      CategoryDescriptor(id: 'a', title: 'A', enabled: true),
      CategoryDescriptor(id: 'b', title: 'B', enabled: false),
      CategoryDescriptor(id: 'c', title: 'C', enabled: true),
    ]);

    final enabled = reg.enabled().map((e) => e.id).toList();
    expect(enabled, ['a', 'c']);
  });
}
