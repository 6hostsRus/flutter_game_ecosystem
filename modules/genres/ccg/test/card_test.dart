import 'package:flutter_test/flutter_test.dart';
import 'package:ccg/ccg.dart';

void main() {
  group('CcgCard', () {
    test('toJson/fromJson round trip', () {
      const c = CcgCard(
        id: 'c001',
        name: 'Firebolt',
        cost: 2,
        rarity: Rarity.rare,
        tags: const ['spell', 'fire'],
        text: 'Deal 3 damage.',
      );

      final j = c.toJson();
      final c2 = CcgCard.fromJson(Map<String, Object?>.from(j));

      expect(c2, equals(c));
      expect(c2.tags, isNot(same(c.tags)));
    });

    test('copyWith applies overrides safely', () {
      const base = CcgCard(
        id: 'c002',
        name: 'Shield',
        cost: 1,
        rarity: Rarity.common,
      );
      final updated = base.copyWith(cost: 2, tags: const ['defense']);
      expect(updated.cost, 2);
      expect(updated.tags, const ['defense']);
      expect(updated.id, base.id);
      expect(updated.name, base.name);
      expect(updated.rarity, base.rarity);
    });

    test('fromJson tolerates missing fields and bad rarity', () {
      final c = CcgCard.fromJson({
        'id': 'x',
        // name missing -> ''
        'cost': 0,
        'rarity': 'mythic', // unknown -> defaults to common
        'tags': ['x', 1, true],
      });
      expect(c.id, 'x');
      expect(c.name, '');
      expect(c.cost, 0);
      expect(c.rarity, Rarity.common);
      expect(c.tags, ['x', '1', 'true']);
      expect(c.text, '');
    });

    test('assertions guard invalid id and cost; empty name allowed', () {
      expect(
        () => CcgCard(id: '', name: 'A', cost: 0, rarity: Rarity.common),
        throwsA(isA<AssertionError>()),
      );
      // Empty name is tolerated for data-driven cards.
      expect(
        () => const CcgCard(id: 'a', name: '', cost: 0, rarity: Rarity.common),
        returnsNormally,
      );
      expect(
        () => CcgCard(id: 'a', name: 'A', cost: -1, rarity: Rarity.common),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
