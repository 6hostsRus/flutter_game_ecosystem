/// CCG card model with serialization and simple validation.
///
/// Note: We use `CcgCard` to avoid colliding with Flutter's Material `Card`.
enum Rarity { common, rare, epic, legendary }

class CcgCard {
  final String id;
  final String name;
  final int cost;
  final Rarity rarity;
  final List<String> tags;
  final String text;

  const CcgCard({
    required this.id,
    required this.name,
    required this.cost,
    required this.rarity,
    this.tags = const [],
    this.text = '',
  })  : assert(id != ''),
        assert(cost >= 0);

  CcgCard copyWith({
    String? id,
    String? name,
    int? cost,
    Rarity? rarity,
    List<String>? tags,
    String? text,
  }) {
    return CcgCard(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      rarity: rarity ?? this.rarity,
      tags: List.unmodifiable(tags ?? this.tags),
      text: text ?? this.text,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'cost': cost,
        'rarity': rarity.name,
        'tags': List<String>.from(tags),
        'text': text,
      };

  static CcgCard fromJson(Map<String, Object?> json) {
    final rarityRaw = json['rarity'];
    Rarity rarity;
    if (rarityRaw is String) {
      rarity = Rarity.values.firstWhere(
        (r) => r.name == rarityRaw,
        orElse: () => Rarity.common,
      );
    } else if (rarityRaw is int) {
      rarity = Rarity.values[(rarityRaw).clamp(0, Rarity.values.length - 1)];
    } else {
      rarity = Rarity.common;
    }

    final tagsRaw = json['tags'];
    final tags = tagsRaw is List
        ? List<String>.unmodifiable(tagsRaw.map((e) => e.toString()))
        : const <String>[];

    return CcgCard(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      cost: (json['cost'] ?? 0) as int,
      rarity: rarity,
      tags: tags,
      text: (json['text'] ?? '') as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CcgCard &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          cost == other.cost &&
          rarity == other.rarity &&
          _listEq(tags, other.tags) &&
          text == other.text;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        cost,
        rarity,
        Object.hashAll(tags),
        text,
      );

  static bool _listEq(List a, List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
