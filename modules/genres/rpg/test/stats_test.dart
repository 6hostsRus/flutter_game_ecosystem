import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/rpg.dart';

void main() {
  test('defaults are 1 and derived values consistent', () {
    const s = Stats();
    expect(s.str, 1);
    expect(s.dex, 1);
    expect(s.intl, 1);
    expect(s.vit, 1);
    expect(s.hp, 10);
    expect(s.mp, 8);
    expect(s.atk, 1 * 2 + 1);
    expect(s.critChancePermille, 5);
  });

  test('copyWith and JSON round trip', () {
    const s = Stats(str: 5, dex: 3, intl: 4, vit: 6);
    final s2 = s.copyWith(dex: 4);
    expect(s2.dex, 4);
    final j = s2.toJson();
    final s3 = Stats.fromJson(Map<String, Object?>.from(j));
    expect(s3.str, 5);
    expect(s3.dex, 4);
    expect(s3.intl, 4);
    expect(s3.vit, 6);
    expect(s3.hp, 60);
    expect(s3.mp, 32);
  });
}
